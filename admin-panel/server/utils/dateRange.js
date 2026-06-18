/**
 * Generates an array of UTC date strings (YYYY-MM-DD) for the nights of a stay.
 *
 * The booking covers nights FROM checkIn UP TO AND INCLUDING the night before checkOut.
 * Example: checkIn=2026-12-20, checkOut=2026-12-23 → ['2026-12-20','2026-12-21','2026-12-22']
 * (3 nights: 20th, 21st, 22nd — guest leaves morning of 23rd)
 *
 * @param {string} checkIn  - 'YYYY-MM-DD'
 * @param {string} checkOut - 'YYYY-MM-DD', must be strictly after checkIn
 * @returns {string[]} array of date strings
 * @throws {Error} if dates are invalid or checkOut is not after checkIn
 */
function generateDateRange(checkIn, checkOut) {
  if (!checkIn || !checkOut) {
    throw new Error('checkIn and checkOut are required.');
  }

  // Parse as UTC midnight to avoid timezone shifts
  const start = new Date(`${checkIn}T00:00:00Z`);
  const end   = new Date(`${checkOut}T00:00:00Z`);

  if (isNaN(start.getTime()) || isNaN(end.getTime())) {
    throw new Error('Invalid date format. Use YYYY-MM-DD.');
  }

  if (end <= start) {
    throw new Error('checkOut must be strictly after checkIn.');
  }

  const dates = [];
  const current = new Date(start);

  // Iterate nights: start inclusive, end exclusive (last night is checkOut - 1 day)
  while (current < end) {
    dates.push(current.toISOString().split('T')[0]);
    current.setUTCDate(current.getUTCDate() + 1);
  }

  return dates;
}

module.exports = { generateDateRange };
