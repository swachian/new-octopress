---
layout: post
title: "JavaScript To TypeScript"
date: 2025-06-15 17:33
comments: true
categories: 
- 技术
---

JS的7个基本类型：undefined, null, boolean, number, symbol, string, bigInt  
array, object, function都是可变的，也就是reference类型的  
string的提取有slice, substring. slice和substring的功能基本一样，但slice支持复数，含义为从右边开始数  
array也有slice，含义和string一样。array还有splice，这个可以用于删除数组中的元素, 且第二个参数表示删除的个数，而slice和substring输入的参数表示index  

基本的运算符、大小关系比较符等  
if, swich, while, do while, for 语句，这些和c一样，for ... in 语句是js也支持的  

函数是顶级的，可以作为引用传来传去，而且在里面实现了**闭包(closure)**,由此实现了状态的记忆和curry（函数生成函数，high order)  
js的函数是没有重载，call和apply可以对某个函数对象进行调用。第一个参数都是传入的this，也就是要执行的对象；优先使用call，尤其搭配新的`...`扩展符，`greet.call(person, ...args)`, apply是传入一个数组，也是在各类语言中常见的一个名字 

Array 可以用字面量`[]`直接定义，也用`[i]`作为index来访问。知名方法有`join, split, slice, push/unshift, pop/shift, sort, reverse, splice`. `splice(0, 2)`表示删除0开始的2项，`splice(2, 1, "a", "b")`删除位置2的1项并插入`"a", "b"`  

`this`指向调用的对象，如为空则在非严格模式下指向全局。lambda的写法（arrow function）没有默认的this。  

传统上，js用Function的construct和prototype来模拟class和继承  
ES6中引入了`...`spread, Destruction `{a, b, c} = obj // the obj has a b and c properties`, 提供了let和const  
还有class extends， 引入symbol解决命名冲突最大使用场景是iterator。  
Promise搭配then使用完成异步，await/async更加先进，但await只能用在async的函数中。Promise本质上是给出resolve和err两个方法体，await和async则需要自己写catch error。  
Map，Set两个基础数据结构，还有不影响gc的WeakMap和WeakSet。  
Proxy Handler实现了给对象及其方法加上proxy的设计模式，便于修改原先的方法而返回handler给客户使用  
`export {}`, `import {x} from . //导入一个或多个变量`, `import x from . // 导入Default`， `import * as matchers from // 在ts中用的较多`  

## React  
新型的React在return时用()包裹的目的就是避免后面换行对内容的干扰，本质上就是返回一个字符串可以被react进一步解析里面的`{}`变量  
返回的内容通常就是html，也包含了需要动态替换的内容和监听的事件处理函数  

RFR(React Fast Fresh), HMF(Hot Module Replacement)实现了react开发中的热更新  
JSX是一种流行的返回格式，在多种Framework中流行  
eslint在8.3之后，配置文件位于eslint.config.js中  

组件的Function是用Pascal风格书写（首字母大写的驼峰拼写），然后就能在html和其他组件中按`<FunctionName>`来引用了  
要监听的事件，可以放在组件的Function里。如果加入单元测试的话，小的组件可能也要考虑export。  
函数理论上传入的对象是`props`, 例如`const Search => (props) => {}`, 但实际上为了简化利用ES6的destruction特点，可以写作`const Search => ({currentValue, setCurrentValue, children}) => {}`  
`children`是一个内部的prop，可以起到类似vue中slot和{} 传给fun的作用。  

`useState`是React的use系列methods之一，本质是同时返回一个类似proxy的handler，这样当使用这个handler修改参数时，可以引起涉及该变量的JSX的修改，从而引发render    
并且这个handler可以作为属性传给其他组件  
```js
const [currentValue, setCurrentValue] = useState(value)

<Search currentValue={currentValue} setCurrentValue={setCurrentValue}>
        Search: &nbsp;&nbsp;
</Search>
```
传入时，也就是`{...item}`用在右边的时候，会自动展开传给函数，甚至可以自动转成nested的。  
定义时，也就是`({ojbectId, ...item})`用在左边时，就把传入对象objectId之外的部分写入item，这个称之为rest。  

`useEffect`可以监测state的变化，并执行里面顶一顶操作。  
```js
const [count, setCount] = useState(0);

  useEffect(() => {
    console.log(`count 变化为: ${count}`);
    document.title = `当前计数: ${count}`;

    // 清理函数（如取消未完成的请求）
    return () => {
      console.log('清理上一次的 effect');
    };
  }, [count]); 
```  
如果不传入第二个参数，那么就是起到只执行一次的作用。  
```js
  useEffect(() => {

  }, []); 
```

customer hooks指利用现有的两个use可以封装自己的customer hook库。  
1. useFetch - 封装数据请求逻辑  
2. useDarkMode - 管理暗黑模式状态  
3. useDebounce - 实现防抖功能  
4. useWindowSize - 监听窗口尺寸变化  

Reducer就是函数式编程里面的reducer，`(state, newValue(or action)) : new_state => {} `  
然后把它和初始state传给useReducer，就像useState一样可以得到一个初始状态的变量和handler，随后每次给这个handler传入一个新的value（或者理解成action）  
```js
const stateReducer = (state, action) => {
    switch (action.type) {
        case 'read':
            ...
            break
        case 'refresh':
            ...
            break
        default:
            throw new error(`Unsupported action type '${action.type}'`)
    }
}

const [state, setState] = useReducer(stateReducer, [])

setState({type: 'read', payload: {}})
```
这里面的state也可以是一个含有多个参数的对象，从而可以把整个组件的操作封装起来。  

现代浏览器自带了`fetch`的异步调用函数，实际上用ajax库更多一些，fetch先返回response，然后再异步读取json  
```js
    const response = await fetch(`${API_ENDPOINT}${param}`)
    const json = await response.json()
```

useCallback把对函数的依赖转换成了对传入的第二个变量的依赖。因为在渲染组件时，Function会重新生成，所以导致引用handleClick的组件都会被重新渲染。使用useCallbak后，就把依赖转化为了传入的数组`[]`，就不会触发渲染了。搭配memo使用，效果更佳，但这会增加代码的复杂度。  
```js
  const handleClick = useCallback(() => {
    setCount(c => c + 1)
  }, [])

  return (
    <div>
      <p>Count: {count}</p>
      <Button onClick={handleClick} />
      <button onClick={() => setOther(o => o + 1)}>Trigger Re-render</button>
    </div>
  )
```

import第三方内容，比如`import axios from 'axios'`

async / await 在React中的用法没有太大不同，在useEffect里面使用时，需要注意要么把useEffect的lambda变成async，要么在这个lambda里面构造async的Function后，调用await才能生效。  

css in React  
```css
/* App.module.css */
.container {
  background-color: #f0f0f0;
  padding: 20px;
}

.title {
  color: blue;
}
```
使用时
```js
// App.tsx
import React from 'react'
import styles from './App.module.css'

export default function App() {
  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Hello, CSS Modules</h1>
    </div>
  )
}
```

vite-plugin-svgr的变化,诀窍在于问号后面跟react，表明这是一个可以用于react的svg图片的组件  
```js
import Check from "./assets/check.svg?react";

<Check height="18px" width="18px" />
```

React.memo与React.useMemo  
useMemo和use系列一样，用第二个参数来控制要不要重新计算，主要针对组件中的method。  
memo主要根据组件的入参来判断要不要重新渲染，主要用于父组件更新而子组件不需要更新的情况。  

```js
useMemo(() => {compute}, [a, b])

const Search = memo(({a, b, c}) => {
    return (
        "<div>content</div>"
    )
})
```

## Learn TypeScript

Learn TypeScript - Full Course for Beginners，done 6小时，基本学会了TypeScript，然后发现她也是C#的设计师设计的, 所以c#的语法很多。
应该TS优先。最早学习js就感觉没有一个架子（blue print)很麻烦，最近终于适应了js的灵活，却发现业界又把TS捧为最佳实践。尽管一开始就应该这样，但世界是个草台班子，实际的发展路线就是这样曲折。  
运行ts或者tsx的可以是`ts-node -emx ...ts`  
ts要给每个参数都定义好type，用的语法比较简单，比如我有一个入参

```js
{
  title: 'Redux',
  url: 'https://redux.js.org/',
  author: 'Dan Abramov, Andrew Clark',
  num_comments: 2,
  points: 5,
  objectID: 1,
},

// 我需要定义下面的type

type Story = {
    title: string,
    url: string,
    author: string,
    num_comments: number,
    points: number
    objectID: number
}

// 使用时
const List = (stories : Story[]) => {

}

// 传入的对象中有Function时，比如List也要传一个function，那么先定义ListProps
type ListProps = {
    stories: Story[],
    removeFunc: (item: Story) => void
}

// 前面reducer的例子可以传入一个action, 但每个type的payload属性不同，此时c#的pattern matching 登场了,在这里叫做Union Type

type Action = {type: 'read'; payload: Story[]}
| {type: 'refresh', payload: String}
// 注意，{}内部的分隔逗号和分号均可以


//调用useState时，也能给入参
const [currentValue, setCurrentValue] = useState<string>('')

// reducer可以这样写
const storiesReducer = (stories: Story[] , action: Action) => {
    switch (action.type) {
      case 'SET_STORIES':
        return action.payload
      case 'DELETE_STORY':
        return stories.filter(s => s != action.payload)
      case 'FILTER_STORY':
        return stories.filter(s => s.title.includes(action.payload))
      default:
        throw new Error(`Invalid action ${action}`)
    }
  }

// 传入一个复杂的react函数的type
type SearchProps = {
  currentValue: string, 
  setCurrentValue: React.Dispatch<React.SetStateAction<string>>, 
  children: ReactNode;
}

// 可以为空以及状态枚举的写法
type Order = {
    id: number
    pizza: Pizza
    sender?: string
    status: "ordered" | "completed"
}

// 定义泛型的写法，<T>是必须的，是通过这个来表示定义了一个泛型
function addToArray<T>(array: T[], item: T): T[] {
    array.push(item)
    return array
}

function getLastItem<T>(array: T[]): T | undefined {
    return array[array.length - 1] 
}

// Partial和Omit，以及可能返回为undefined，Omit表示传入了的类型不包含的属性，提醒后面需要增加，
// 和c#不同，ts这里的关键字也都是Pascal式的写法，而c#是全小写
function addNewPizza(pizza: Omit<Pizza, "id">): Pizza | undefined{
    menu.push({
        id: nextPizzaId++,
        ...pizza
    })
    return menu[menu.length - 1]
}

// Partial把所有属性变为可选
type PartialUser = Partial<User>;
/* 等价于：
type PartialUser = {
  id?: number;
  name?: string;
  age?: number;
  email?: string;
};
*/
```