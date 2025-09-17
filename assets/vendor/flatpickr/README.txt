This is a tiny offline shim ("flatpickr-lite") created just to provide a date/time picker
on hosts without internet access. It mimics a *very small* subset of the Flatpickr API:
- enableTime
- dateFormat: "Y-m-d" or "Y-m-d H:i"
- time_24hr
- locale: "pl"

It uses native <input type="date"> and <input type="time"> under the hood.
If you later get internet access, replace these files with the real Flatpickr 4.6.13 files.
