---
layout: post
title: "Spring的@SessionAttributes和@ModelAttribute在Redirect时的特殊表现"
date: 2015-11-14 22:50
comments: true
categories:
- java
- spring
- 技术
---

`@ModelAttribute` 在Spring中有两个地方可以填写：

* Controller的Action method的参数前标注，提示需要设置该值  
```java
@ModelAttribute
public void getUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model) {

  ...
  model.addAttribute("mdn", mdn);
  model.addAttribute("userInfo", userInfo);
  model.addAttribute("helper", new HomeHelper(userInfo));

}
```

* Controller中单独的方法前标注，该方法通常不是action，但加注`@ModelAttribute`后会在Action method执行前被调用  
```java
@RequestMapping(value = "/addDiy", method = RequestMethod.GET)
public ModelAndView addDiy(@ModelAttribute("operator") String operator) {
  ...
}
```

使用效果来讲就是确保第一种情况下，action method的参数会被设置，而设置的根据主要是以下4种：

1. 来自`@SessionAttributes`使用中被设置在session中的`ModelAttribute`  
2. 上面提到的第二个使用的方法中产生的对象  
3. 基于URI的模板变量+type converter  
4. 直接new的，即默认的构建方法

```java
@Controller
@RequestMapping(value = "/home")
@SessionAttributes({"operator" })
public class HomeController {
    ...
    /*登陆验证，成功后转至home action，验证失败则继续显示login页面*/
	@RequestMapping(value="login", method = RequestMethod.POST)
	public String loginPost(HttpSession session, Model model, String username, String password, String yzm, RedirectAttributes redirectAttributes) {
		redirectAttributes.addFlashAttribute("username", username);
		redirectAttributes.addFlashAttribute("password", password);

		/*检测验证码是否正确*/
		if (!StringUtils.equals((String) session.getAttribute("rand"), yzm)) {
			redirectAttributes.addFlashAttribute("errorMessage", "验证码不正确，请输入正确的验证码");
			return "redirect:/home/login";
		}

		CInterfaceOper ciop = null;
		String status = null;
		try {
			ciop = new CInterfaceOper(username, password);
			status = ciop.getUserStatus();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	    if (StringUtils.equals(status, ConstVar.Status.Normal)) { //用户业务状体正常


			//由modelattribute获取operator时使用
			// redirect的情况下，加在model里面不会被sessionAttributes处理到session中
			//model.addAttribute("operator", operator);
			redirectAttributes.addFlashAttribute("operator", username);

			String lastUri = (String)session.getAttribute(ConstVar.REQUEST_URI);
			if (StringUtils.isEmpty(lastUri)) {
				return "redirect:/home";
			} else {
				return "redirect:"+lastUri;
			}

	    } else {
	    	redirectAttributes.addFlashAttribute("errorMessage", "登录失败，请检查用户名和密码");
	    	return "redirect:/home/login";
	    }
	}
}

```

在`Controller`类前标注的`@sessionAttributes`就可以把action中的model包含的同名属性固化在session中。
但是，因为整个action的返回不是直接渲染jsp，而是使用了`redirect:/home`这样的重定向语句，所以起初并没有奏效。
而是要把`operator`放在`redirectAttributes`中，才会被固化。这说明spring选择固化属性是当且仅当
在渲染页面前。

在需要使用该session的属性action处，直接使用下面代码即可。

```java
@RequestMapping(value = "/addDiy", method = RequestMethod.GET)
public ModelAndView addDiy(@ModelAttribute("operator") String operator) {
  ModelAndView mav = new ModelAndView();
    List<RingRequest> ringrequest=ConstVar.DIV_LIST;
    RingRequest ringrequest1=null;
    if(ringrequest!=null&&ringrequest.size()>0){
       ringrequest1=lingyingdiyService.add(ringrequest.get(0), operator);
    }
  mav.setViewName("webapp/ringDiy/lingyindiy4");
  mav.addObject("ringrequest", ringrequest1);
  return mav;
}
```

在Session范围内使用注入的逻辑还是很清晰的，只是需要注意一下redirect带来的坑。
