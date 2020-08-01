module.exports = {
  purge: [],
  theme: {
    extend: {
        fontFamily: {
            'bodytext': ['Montserrat', 'sans-serif'] 
        },
        colors: {
            'primary': {            
                '300': '#3CBAC8',
                '500': '#00AABD',
                '700': '#007C8A',
                '900': '#283640',
//                '900': '#12393D',
              },
        },    
    },
  },
  variants: {
    borderStyle: ['responsive', 'hover'],
  },
  plugins: [],
}
