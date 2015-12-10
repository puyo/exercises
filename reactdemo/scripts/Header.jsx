import React from 'react';

const Header = React.createClass({
  propTypes: {
    name: React.PropTypes.string.isRequired
  },

  render() {
    return(
      <header>
        Hello {this.props.name}, I'm the header.
      </header>
    );
  }
});

export default Header;
