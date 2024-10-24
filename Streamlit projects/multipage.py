"""
This file is the framework for generating multiple Streamlit applications 
through an object oriented framework. 
"""

# Import necessary libraries 
import streamlit as st

# Define the multipage class to manage the multiple apps in our program 
class MultiPage: 
    """Framework for combining multiple streamlit applications."""

    def __init__(self) -> None:
        """Constructor class to generate a list which will store all our applications as an instance variable."""
        self.pages = []
    
    def add_page(self, title, func, *args, **kwargs) -> None: 
        """Class Method to Add pages to the project
        Args:
            title ([str]): The title of page which we are adding to the list of apps 
            
            func: Python function to render this page in Streamlit
        """

        self.pages.append(
            {
                "title": title, 
                "function": func,
                "args": args,
                "kwargs": kwargs
            }
        )

    def run(self):
        # Drodown to select the page to run  
        st.sidebar.image('logo.png', width=250)
        st.sidebar.title("SeaFirst Insurance")
        st.sidebar.write("### Choose your desired application")
        page = st.sidebar.selectbox(
            'Application:', 
            self.pages, 
            format_func=lambda page: page['title']
        )

        # run the app function 
        page['function'](*page["args"], **page["kwargs"])