---
layout: post
title: "士别三日 Jave Web非复昔日阿蒙"
date: 2014-05-31 10:16
comments: true
categories:
- 技术
- spring
- java
---

六七年来，小组的Java Web开发是用SSH（Struts2+Spring+Hibernate）的框架。
Struts2充当胶水层，完成request参数的封装、controller的映射以及视图和控制层之间的参数传递。
Spring在其中充当了注入的角色。Hibernate负责数据持久化。
这个架构稳定使用了五年以上。

之所以一直使用，一方面在于对Webwork(Struts2)的感情，
毕竟曾经这个东西在替换struts1时让人映像深刻。其次，
一个开发架构的迁移牵涉到整个小组，引入、推广和维护都有成本的，
一成不变固然不行，一直切换也难免开销过大。同时，SSH招收熟手也相对容易些。

然而，Struts2毕竟多年已经没什么发展，
同时它的安全漏洞始终没能很好地解决，加上老架构也确实使用的时间有点长了。
因此开始尝试新的方案。主要目标就是替换掉Struts2，也就是选用其他的Controller组件。
而考察的对象就是Spring，确切地说是Spring MVC。

而在了解的过程中，又仔细学习了一下Spring JPA。当MVC+JPA结合在一起后，
发现Java Web的进步已然很大。而Spring MVC可以说是Rails的山寨版，
或者可以称之为 Java on Rails with Java Style。Spring MVC的设计者
可以说从Rails中借鉴了很多东西，但又最终使用Java的方式实现了出来。

在初学Rails的时候，彼时的版本是1.2.6，一直有个疑问，就是Java能否也有一个
像Ruby on Rails那样好的Web开发框架？当时有的牛人给出的答案是不依赖Ruby，
DHH变不出那么多魔术。但是，如今的Spring MVC至少已经赶上了Rails 2的开发便利程度，
虽然还逊于最新的Rails版本。所以，确切地说，Java至少也可以拥有和Rails 2 **一样方便**的Web框架，
只是需要投入**更多**的人力，也需要等待长的多的时间。而最后出来的东西肯定还是充满Java味道的。
现在的Rails已经走的更远了，但Java Web提高的程度这几年却更加显著了。

看一下Controller：

```java
	@RequestMapping(value = "update/{id}", method = RequestMethod.GET)
	public String updateForm(@PathVariable("id") Long id, Model model) {
		model.addAttribute("user", userService.getUser(id));
		model.addAttribute("action", "update");
		return "user/userForm";
	}

	@RequestMapping(value = "update/{id}", method = RequestMethod.POST)
	public String update(@Valid @ModelAttribute("user") User user, RedirectAttributes redirectAttributes) {
		userService.updateUser(user, user.getNumber2(), user.getCurrentshownumber());
		redirectAttributes.addFlashAttribute("message", "更新任务成功");
		return "redirect:/simuser/";
	}

```

Restful风格的Url，通过声明`@ModelAttribute`可以注入参数到模型中，
`@PathVariable`可以实现从url路径中获取参数，
`userService`是注入的服务组件，`model.addAttribute`则将controller的内容注入给页面模板。
整个风格已经十分简洁。如果需要其他组件，如`session`或者`request`，
只要在类或者方法的参数中声明即可。`return "user/userForm"`则通知渲染user目录下的userForm.jsp模板

Spring JPA则是最方便的Java ORM描述工具。寻找多年的Java版ActiveRecord终于有了着落。
需要定义两个文件：1：model本身，2：一个dao文件（reposity）

- model：

```java

//JPA标识
@Entity
@Table(name = "users")
public class User extends IdEntity {
	private String login;
  ...
	private Set<Phonenumber> phonenumbers;
	private List<Useroperlog> useroperlogs;

	@NotBlank
	public String getNumber1() {
		return number1;
	}

	public void setNumber1(String number1) {
		this.number1 = number1;
	}

	@Transient
	public String getNumber2() {
		return number2;
	}

	public void setNumber2(String number2) {
		this.number2 = number2;
	}

	@Transient
	public String getCurrentshownumber() {
		return currentshownumber;
	}

	public void setCurrentshownumber(String currentshownumber) {
		this.currentshownumber = currentshownumber;
	}
	// join column is in table for Phonenumber
	@OneToMany(fetch=FetchType.LAZY,orphanRemoval=true,cascade=CascadeType.ALL)
	@JoinColumn(name = "userid")
	public Set<Phonenumber> getPhonenumbers() {
		return phonenumbers;
	}

	public void setPhonenumbers(Set<Phonenumber> phonenumbers) {
		this.phonenumbers = phonenumbers;
	}

	@OneToMany(fetch=FetchType.LAZY)
	@JoinColumn(name = "userid")
	public List<Useroperlog> getUseroperlogs() {
		return useroperlogs;
	}

	public void setUseroperlogs(List<Useroperlog> useroperlogs) {
		this.useroperlogs = useroperlogs;
	}
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}

```

啰嗦是还是有点啰嗦，这个毕竟是java。DAO相对代码少一些。

- DAO文件：

```java
public interface UserDao extends PagingAndSortingRepository<User, Long>, JpaSpecificationExecutor<User> {

	//Page<User> findByUserId(Long id, Pageable pageRequest);

	User findByNumber1(String number1);
}
```
这个dao提供了很多默认的方法，包括`findAll`, `findOne`, `save`，底层的
实现还有很多内容，但使用的话确实只需要声明这些就行了。

- 在Service文件中可这样使用:

```java
	public void updateUser(User entity, String number2, String showNumber) {
		loadNumber2(entity);
		resetCurrentshownumber(entity, showNumber);
		resetNumber2(entity, number2);
		userDao.save(entity);
	}

	public void deleteUser(Long id) {
		userDao.delete(id);
	}

```

而在页面处理上，几年前的Servlet 2.5开始，EL表达式取得了首要被支持的地位。

```java
${user.name}
```
对比ruby在erb里常用的

`<%=user.name%> `

EL表达式其实就是代码了。Java不具备动态语言的特性，所以需要另外造一套表达式。
ruby的话，直接使用scriptlet其实效果更好也更直白。个人其实认为，逻辑判断、
取值等都应该使用语言本身，而不是要借助标签。EL表达式是对Java语言的一种很好的补充。
对Java Web的开发状况改善许多。但在迭代、逻辑判断方面，
标签使用的机会还是满多的，这个只能再等发展的变化了。

以上是已经进步显著的几个方面。但在布局、分页以及整合上，Spring并没有提供
一步到位的东西。所以需要进一步参考[SpringSide](https://github.com/springside/springside4)。
这是一个中国人主推的Java Web开发实践整合的开源项目。里面提供了整合的样例，
其实本身也可以当做一个开发模板来对待。

从[SpringSide](https://github.com/springside/springside4)上也可以追踪
Java Web开发历史的变迁，看了几年前的版本也是主要基于SSH的，最近一两年切换到了Spring MVC。
同时它也是使用的JPA来做ORM的描述。在各方面都很贴合我的需求和口味。考虑到这个项目维护多年，
且始终保持着很不错的实践，在此推荐一下。

花费多年时间，Jave Web非复昔日阿蒙。开发中的痛苦状况已经得到了极大的改善。
值得刮目相待。Spring确实极大地改变了Java Web开发，而Rails则影响了十年来的Web开发。
