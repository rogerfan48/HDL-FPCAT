from PIL import Image
import os

def png_to_coe(input_path, output_path):
    """
    Convert PNG image to COE file format.
    Output encoding:
    1: black
    0: transparent
    """
    try:
        # Check if input file exists
        if not os.path.exists(input_path):
            print(f"Error: Input file '{input_path}' does not exist!")
            return False

        # Open the image
        with Image.open(input_path) as img:
            # Convert to RGBA if not already
            img = img.convert('RGBA')
            width, height = img.size
            
            # Open output file
            with open(output_path, 'w') as f:
                # Write header
                f.write("memory_initialization_radix=2;\n")
                f.write("memory_initialization_vector=\n")
                
                # Process each pixel
                pixels = list(img.getdata())
                total_pixels = len(pixels)
                
                for i, pixel in enumerate(pixels):
                    r, g, b, a = pixel
                    
                    # Check if pixel is transparent (0) or black (1)
                    if a < 128:  # Transparent
                        bit_value = '0'
                    else:
                        # For non-transparent pixels, all non-transparent pixels are considered black
                        bit_value = '1'
                    
                    # Write to file with proper formatting
                    if i == total_pixels - 1:
                        f.write(bit_value + ";")  # Last value ends with semicolon
                    else:
                        f.write(bit_value + ",\n")
        
        print(f"Successfully converted '{input_path}' to '{output_path}'")
        return True

    except Exception as e:
        print(f"Error while processing the file: {str(e)}")
        return False

def main():
    print("PNG to COE Converter (Binary: Black or Transparent)")
    print("Encoding:")
    print("1: Black")
    print("0: Transparent")
    print("-" * 40)
    
    while True:
        # Get input file name
        input_file = input("Input file(.png) [or 'q' to quit]: ").strip()
        
        # Check if user wants to quit
        if input_file.lower() == 'q':
            print("Goodbye!")
            break
        
        # Get output file name
        output_file = input("Output file(.coe): ").strip()
        
        # Add default extensions if not provided
        if not input_file.lower().endswith('.png'):
            input_file += '.png'
        if not output_file.lower().endswith('.coe'):
            output_file += '.coe'
        
        # Convert file
        png_to_coe(input_file, output_file)
        print("-" * 40)  # Separator line

if __name__ == "__main__":
    main()