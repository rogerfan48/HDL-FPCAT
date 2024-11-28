from PIL import Image
import os

def png_to_coe(input_path, output_path):
    """
    Convert PNG image to COE file format.
    Output encoding:
    11: transparent
    10: red
    01: black
    00: white
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
                    
                    # Initialize with white (00)
                    bit_value = '00'
                    
                    # Check transparency first
                    if a < 128:
                        bit_value = '11'  # Transparent
                    else:
                        # For non-transparent pixels, check colors
                        if r > 200 and g < 100 and b < 100:
                            bit_value = '10'  # Red (high R, low G and B)
                        else:
                            # Check for black/white
                            avg_color = (r + g + b) / 3
                            bit_value = '01' if avg_color < 128 else '00'  # 01 for black, 00 for white
                    
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
    print("PNG to COE Converter (with Red Color Support)")
    print("Encoding:")
    print("11: Transparent")
    print("10: Red")
    print("01: Black")
    print("00: White")
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