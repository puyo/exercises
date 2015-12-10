import React from 'react';

const Form = React.createClass({

  getInitialState() {
    return {comment: ""};
  },

  alertComment(event) {
    event.preventDefault();
    alert(this.state.comment);
  },

  onChange(event) {
    this.setState({comment: event.target.value});
  },

  render() {
    return(
      <form onSubmit={this.alertComment}>
        <div className="field">
          <textarea
              cols="100"
              rows="10"
              value={this.state.comment}
              placeholder="Your comment"
              autofocus={true}
              onChange={this.onChange}
          />
        </div>
        <button type="submit">Submit</button>
        <pre>
          {this.state.comment}
        </pre>
      </form>
    );
  }
});

export default Form;
