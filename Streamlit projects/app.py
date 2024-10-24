import streamlit as st
from multipage import MultiPage
from dashboard1 import app as dashboard1_app
from dashboard2 import app as dashboard2_app
from dashboard3 import app as dashboard3_app

# Create an instance of the app 
app = MultiPage()

# Title of the main page
st.set_page_config(layout="wide")
#app.add_page("Standard Farm Rater", dashboard1_app)
app.add_page("Standard Farm Rater", dashboard2_app)
app.add_page("Loydds Standard Rate Estimator", dashboard3_app)

# The main app
app.run()