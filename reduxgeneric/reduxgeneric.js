const {createStore} = require('redux')

// Wrap a redux store to make it more convenient to set up
class GenericReduxStore {
    constructor(initialState, reducers) {
        function generalPurposeReducer(state = initialState, action) {
            if (!reducers.hasOwnProperty(action.type)) {
                if (action.type !== '@@INIT') {
                    console.warn('Unknown action: ', action.type)
                }
                return state
            }
            return reducers[action.type](state, action.args)
        }

        this._reduxStore = createStore(generalPurposeReducer,
                                       window &&
                                       window.devToolsExtension &&
                                       window.devToolsExtension())

        this.dispatch = {}
        // Add methods for dispatching based on reducers provided
        for (let type in reducers) {
            if (reducers.hasOwnProperty(type)) {
                this.dispatch[type] = function(args) {
                    return this._reduxStore.dispatch({type, args})
                }
            }
        }
    }

    // TODO: delegate other redux store methods as appropriate
    subscribe(fn) { return this._reduxStore.subscribe(fn) }
    getState() { return this._reduxStore.getState() }
}

// Now the store, actions and reducers are all defined in one go like this:

const store = new GenericReduxStore(0, {
    increment(state) { return state + 1 },
    decrement(state) { return state - 1 },
    incrementBy(state, n) { return state + n },
})

store.dispatch.increment()

console.log(store)

module.exports = store

// Which seems way more DRY and convenient than spreading them around
// in different directories, no?
