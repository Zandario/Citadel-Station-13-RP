const path = require('path');

module.exports = {
  entry: './js/index.js', // This should be your main file that imports the others
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
};
