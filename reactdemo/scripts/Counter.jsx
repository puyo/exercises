import React from 'react';

const Counter = React.createClass({

  getInitialState() {
    return {number: 1};
  },

  incrementNumber() {
    this.setState({number: this.state.number + 1});
  },

  render() {
    return(
      <div>
        <p>Count: {this.state.number}</p>
        <button type="button" onClick={this.incrementNumber}>Increment</button>
      </div>
    );
  }
});

export default Counter;
