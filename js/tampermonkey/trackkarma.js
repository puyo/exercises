// ==UserScript==
// @name         Track Karma Convenience
// @namespace    http://tampermonkey.net/
// @license      Creative Commons BY-NC-SA
// @encoding     utf-8
// @version      0.1
// @description  Make it easier to mark attendance with Track Karma
// @author       puyo
// @include      https://app.trackkarma.com/trainings
// @grant        none
// @require      https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js
// @updateURL    https://raw.githubusercontent.com/puyo/exercises/master/js/tampermonkey/trackkarma.js
// ==/UserScript==

(function() {
    'use strict';

    const iframe = document.createElement('iframe')
    iframe.setAttribute('name', 'postTarget')
    iframe.style.display = 'none'
    document.querySelector('body').appendChild(iframe)

    const csrfValue = () => document.querySelector('meta[name=csrf-token]').getAttribute('content')
    const csrfParam = () => document.querySelector('meta[name=csrf-param]').getAttribute('content')

    const cards = document.querySelectorAll('.training-card')
    cards.forEach(function(card) {
        let present = card.querySelector('.availability-present') != null
        const link = card.querySelector('a[data-remote=true]')
        if (!link) {
            return
        }
        const form = document.createElement('form')
        const href = link.getAttribute('href')
        const action = href.replace('/edit', '')
        const newValue = () => present ? 'absent' : 'present'
        const buttonLabel = () => present ? 'Set absent' : 'Set present'
        let field

        card.style.position = 'relative'

        form.setAttribute('action', action)
        form.setAttribute('target', 'postTarget')
        form.setAttribute('accept-charset', 'UTF-8')
        form.setAttribute('method', 'post')
        form.style.position = 'absolute'
        form.style.top = '5px'
        form.style.right = '5px'

        field = document.createElement('input')
        field.setAttribute('type', 'hidden')
        field.setAttribute('name', 'utf8')
        field.setAttribute('value', '✓')
        form.appendChild(field)

        field = document.createElement('input')
        field.setAttribute('type', 'hidden')
        field.setAttribute('name', '_method')
        field.setAttribute('value', 'patch')
        form.appendChild(field)

        field = document.createElement('input')
        field.setAttribute('type', 'hidden')
        field.setAttribute('name', csrfParam())
        field.setAttribute('value', csrfValue())
        form.appendChild(field)

        field = document.createElement('input')
        field.setAttribute('type', 'hidden')
        field.setAttribute('name', 'availability[status]')
        field.setAttribute('value', newValue())
        const availField = field
        form.appendChild(field)

        field = document.createElement('input')
        field.setAttribute('type', 'hidden')
        field.setAttribute('name', 'availability[comment]')
        field.setAttribute('value', '')
        form.appendChild(field)

        field = document.createElement('input')
        field.setAttribute('type', 'submit')
        field.setAttribute('value', buttonLabel())
        const submitField = field
        form.appendChild(field)

        const success = () => {
            present = !present

            const avail = card.querySelector('.training-availability')
            avail.classList.toggle('availability-present', present)
            avail.classList.toggle('availability-absent', !present)

            const icon = avail.querySelector('.fa')
            icon.classList.toggle('fa-check', present)
            icon.classList.toggle('fa-close', !present)

            const attendances = card.querySelector('.attendances')
            attendances.textContent = parseInt(attendances.textContent) + (present ? 1 : -1)

            availField.setAttribute('value', newValue())
            submitField.setAttribute('value', buttonLabel())
            return true
        }

        const $form = jQuery(form)
        $form.submit(function(event) {
            event.preventDefault()
            jQuery.post($form.attr('action'), $form.serialize(), success, 'html')
        })

        card.appendChild(form)
    })
})();
