from PIL import Image
import os

def png_to_coe(input_path, output_path):
    """
    Convert PNG image to COE file format.
    First bit: 1 for transparent, 0 for non-transparent
    Second bit: 1 for black, 0 for white
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
                    
                    # Determine transparency (first bit)
                    # Alpha channel < 128 means transparent
                    is_transparent = '1' if a < 128 else '0'
                    
                    # Determine color (second bit)
                    # For non-transparent pixels, check if it's black or white
                    # Consider a pixel black if its average RGB value is less than 128
                    is_black = '0'  # Default for transparent pixels
                    if a >= 128:  # Only check color for non-transparent pixels
                        avg_color = (r + g + b) / 3
                        is_black = '1' if avg_color < 128 else '0'
                    
                    # Combine bits
                    bit_value = is_transparent + is_black
                    
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
    print("PNG to COE Converter")
    print("-" * 20)
    
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
        print("-" * 20)  # Separator line

if __name__ == "__main__":
    main()