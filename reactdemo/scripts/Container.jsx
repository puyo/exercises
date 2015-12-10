import React from 'react';
import Counter from './Counter';
import Form from './Form';

const Container = React.createClass({
  render() {
    return(
      <div>
        <Counter/>
        <Form/>
      </div>
    );
  }
});

export default Container;
