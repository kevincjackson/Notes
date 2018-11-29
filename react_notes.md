# React

## Isn't mixing CSS and JS a bad?

Usually yes.

The philosophy with React is that the Component is king.

Since modern interaction couples CSS and JS anyway, the emphasis is to
create a reusable piece: the component.

The drawback is that it is harder for programmers and designers to work
together, or at the least it favors programmers at the expense of designers.

## React Classes are Functions

React Class

```js
class Hello extends Component {
  render() {
    return <h1>Hello {this.props.name}!</h1>;
  }
}
```

Function

```js
const Hello = props => {
  return <h1>Hello {props.name}!</h1>;
};
```

## Routing

```js
// Set state
this.state = { route: "home" };

// Handler
onRouteChange = route => {
  this.setState({ route: route });
};

// Event
<a onClick={onRouteChange("home")}>Home</a>;
```

## Making Non Mutating Changes
In order for React to efficiently make updates, it looks for new objects (not mutated objects). Use the following methods.

Array: Use `slice`.
```js
const board = ['x', 'o', null];
const new_board = board.slice();
new_board[2] = 'x';
board // ['x', 'o', null]
new_board // ['x', 'o', 'x']
```

Object: Use `Object.assign(target, ...sources)`
```js
const color = { id: 1, name: "blue" };
const new_color = Object.assign({}, color, {name: "Blue"});
color; // { id: 1, name: "blue" }
new_color // { id: 1, name: "Blue" }
```

## Thinking in React (Procedure)
TLDR: Make all your data flow from the top down.
1. Make mock data / model. **Do not skip.**
2. Make static heirarchical components. Don't worry about state at this step.
3. Now determine what's state. If it changes, it's state.
4. Data flowing down is passed as props.
5. Data which needs to flow up is handled like this. A parent needs to own the state (data). Pass data *and a handler* to the child.
