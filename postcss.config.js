const postcssimport = require('postcss-import');
const autoprefixer = require('autoprefixer');
const tailwindcss = require('tailwindcss')('./tailwind/tailwind.config.js');

module.exports  = {
    plugins: [
        postcssimport,
        tailwindcss,
        autoprefixer,
    ],
};
