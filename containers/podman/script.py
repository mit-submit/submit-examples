import time
import os

def clear_console():
    """Clear the console screen."""
    os.system('cls' if os.name == 'nt' else 'clear')

def print_dancing_man(message, frames, delay=0.5):
    """Print the man dancing with a speech bubble."""
    speech_bubble = "| {message:<43} |".format(message=message)
    speech_bubble = "+" + "-" * (len(message)+2) + "+\n" + speech_bubble + "\n+" + "-" * (len(message)+2) + "+"
    while True:
        for i in range(len(frames)):
            clear_console()
            print(speech_bubble)
            print(frames[i], "\t", frames[(i+1)%4], "\t", frames[(i+2)%4], "\t", frames[(i+3)%4])
            time.sleep(delay)

if __name__ == "__main__":
    text = "Wow I loveeeee Docker, I can do anything in here!"

    dancing_frames = [
        r"""
           O
          /|\
          / \
        """,
        r"""
           O
          \|/
          / \
        """,
        r"""
           O
          /|\
          \ /
        """,
        r"""
           O
          \|/
          \ /
        """
    ]

    print_dancing_man(text, dancing_frames)
