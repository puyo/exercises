// ==UserScript==
// @name         Track Karma Convenience
// @namespace    http://tampermonkey.net/
// @license      Creative Commons BY-NC-SA
// @encoding     utf-8
// @version      1.0
// @description  Make it easier to mark attendance with Track Karma
// @author       puyo
// @include      https://app.trackkarma.com/trainings*
// @grant        GM_addStyle
// @updateURL    https://raw.githubusercontent.com/puyo/exercises/master/js/tampermonkey/trackkarma.js
// ==/UserScript==

GM_addStyle(`
.set-availability-buttons {
  position: abolute;
  top: 100%;
}

.availability-absent .button.set-absent { display: none; }
.availability-absent_major .button.set-absent { display: none; }

.availability-present .button.set-present { display: none; }
.availability-present_major .button.set-present { display: none; }

/* avoid hover effect on this element which isn't a link that affects our buttons */
.training-availability:hover {
    -webkit-filter: initial !important;
    filter: initial !important;
}
`)
;(function () {
    'use strict'

    const csrfValue = () => document.querySelector('meta[name=csrf-token]').getAttribute('content')
    const csrfParam = () => document.querySelector('meta[name=csrf-param]').getAttribute('content')

    document.querySelectorAll('.training-card, .availability-card').forEach(function (card) {
        const link = card.querySelector('a[data-remote=true]')

        if (!link) {
            return
        }

        const href = link.getAttribute('href')
        const action = href.replace('/edit', '')
        const avail = card.querySelector('.training-availability, .member-availability')

        avail.style.position = 'relative'

        const setValue = (value, present) => {
            const body = new URLSearchParams([
                ['utf8', '✓'],
                ['_method', 'patch'],
                [csrfParam(), csrfValue()],
                ['availability[status]', value],
            ])

            fetch(action, {
                method: 'POST',
                body: body,
            })
                .then((res) => {
                    if (res.ok) {
                        success(present)
                    } else {
                        console.error(res)
                    }
                })
                .catch((err) => console.error(err))
        }

        const success = (present) => {
            const oldPresent = card.querySelector('.availability-present') != null

            if (oldPresent === present) {
                return
            }

            avail.classList.toggle('availability-present', present)
            avail.classList.toggle('availability-absent', !present)

            const icon = avail.querySelector('.fa')
            icon.classList.toggle('fa-check', present)
            icon.classList.toggle('fa-close', !present)

            const attendances = card.querySelector('.attendances')
            if (attendances) {
                attendances.textContent = parseInt(attendances.textContent) + (present ? 1 : -1)
            }
        }

        const makeButton = (label, klass, value, present) => {
            const button = document.createElement('button')
            button.classList.add('button')
            button.classList.add('small')
            button.classList.add('secondary')
            button.classList.add(klass)
            button.innerHTML = label
            button.addEventListener('click', (event) => {
                event.preventDefault()
                setValue(value, present)
            })
            return button
        }

        const setPresent = makeButton('<i class="fa fa-check"></i>', 'set-present', 'present', true)
        const setAbsent = makeButton('<i class="fa fa-close"></i>', 'set-absent', 'absent', false)

        const buttonContainer = document.createElement('div')
        buttonContainer.classList.add('set-availability-buttons')
        buttonContainer.appendChild(setPresent)
        buttonContainer.appendChild(setAbsent)
        avail.appendChild(buttonContainer)
    })
})()
