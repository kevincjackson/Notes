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
      return (
          <h1>Hello {this.props.name}!</h1>
      );
    }
}
```

Function
```js
const Hello = (props) => {
    return (
        <h1>Hello {props.name}!</h1>
    );
};
```
