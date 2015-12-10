import React from 'react';
import Header from './Header';
import Container from './Container';
import Footer from './Footer';

const Hello = React.createClass({
  render() {
    return(
      <div>
        <Header name="Gigi" />
        <Container />
        <Footer />
      </div>
    );
  }
});

export default Hello;
