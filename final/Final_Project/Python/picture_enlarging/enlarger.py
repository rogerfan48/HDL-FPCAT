# from PIL import Image

# # Function to enlarge the image
# def enlarge_image(input_path, output_path, new_size=(20, 100)):
#     try:
#         # Open the input image
#         with Image.open(input_path) as img:
#             # Resize the image to the new size using nearest neighbor (preserves pixel art)
#             enlarged_img = img.resize(new_size, Image.NEAREST)
#             # Save the enlarged image to the output path
#             enlarged_img.save(output_path)
#             print(f"Image successfully enlarged and saved to {output_path}")
#     except Exception as e:
#         print(f"An error occurred: {e}")

# # Input and output file paths
# input_file = "Cat.png"  # Replace with the path to your 20x20 image
# output_file = "Cat_en.png"  # Path to save the enlarged image

# # Enlarge the image
# enlarge_image(input_file, output_file)
import os
from PIL import Image

# Function to enlarge image
def enlarge_image(input_path, output_path, scale_factor=4):
    try:
        with Image.open(input_path) as img:
            # Calculate new size (4x original dimensions)
            new_size = (img.width * scale_factor, img.height * scale_factor)
            # Resize image using nearest neighbor to preserve pixel art
            enlarged_img = img.resize(new_size, Image.NEAREST)
            # Save the enlarged image
            enlarged_img.save(output_path)
            print(f"Enlarged: {input_path} -> {output_path}")
    except Exception as e:
        print(f"Error processing {input_path}: {e}")

# Main function to scan directory and process PNG files
def process_images_in_directory(directory, scale_factor=4):
    # Loop through all files in the specified directory
    for filename in os.listdir(directory):
        if filename.lower().endswith(".png"):  # Process only .png files
            input_path = os.path.join(directory, filename)
            # Generate new file name with "_en" suffix
            name, ext = os.path.splitext(filename)
            output_filename = f"{name}_en{ext}"
            output_path = os.path.join(directory, output_filename)
            # Enlarge the image
            enlarge_image(input_path, output_path, scale_factor)

# Directory to scan for PNG files
directory = "."  # Current directory; change this to a specific folder path if needed

# Run the script
if __name__ == "__main__":
    process_images_in_directory(directory, scale_factor=5)

