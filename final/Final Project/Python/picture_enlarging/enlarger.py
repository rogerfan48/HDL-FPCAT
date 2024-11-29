from PIL import Image

# Function to enlarge the image
def enlarge_image(input_path, output_path, new_size=(40, 20)):
    try:
        # Open the input image
        with Image.open(input_path) as img:
            # Resize the image to the new size using nearest neighbor (preserves pixel art)
            enlarged_img = img.resize(new_size, Image.NEAREST)
            # Save the enlarged image to the output path
            enlarged_img.save(output_path)
            print(f"Image successfully enlarged and saved to {output_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Input and output file paths
input_file = "Cat.png"  # Replace with the path to your 20x20 image
output_file = "Cat_en.png"  # Path to save the enlarged image

# Enlarge the image
enlarge_image(input_file, output_file)
