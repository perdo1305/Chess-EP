from PIL import Image
import numpy as np
import os

def bmp_to_binary_matrix_and_save(file_path):
    # Open the BMP file
    with Image.open(file_path) as img:
        # Ensure the image is in monochrome (1-bit)
        if img.mode != '1':
            raise ValueError("The BMP file is not a 1-bit monochrome image.")
        
        # Convert image to numpy array
        binary_array = np.array(img, dtype=np.uint8)
    
    # Invert values because '1' in PIL monochrome means black, we want '1' to mean white
    binary_matrix = 1 - binary_array
    
    # Save the binary matrix in the requested format
    txt_file_path = os.path.splitext(file_path)[0] + ".txt"
    with open(txt_file_path, 'w') as f:
        formatted_lines = [
            f"    ({', '.join(map(str, row))}),"
            for row in binary_matrix
        ]
        f.write("\n".join(formatted_lines))
    print(f"Binary matrix saved to {txt_file_path}")

    return binary_matrix

# Example usage
bmp_file = "empety.bmp"  # Replace with your BMP file path
binary_matrix = bmp_to_binary_matrix_and_save(bmp_file)
