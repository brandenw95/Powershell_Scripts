import streamlit as st
from fpdf import FPDF
import base64

# Function to create PDF
def create_pdf(premium_inputs, client_info, scheduled_items, notes):
    pdf = FPDF()
    pdf.add_page()
    
    # Title
    pdf.set_font("Arial", size=12)
    pdf.cell(200, 10, txt="Lloyd Standard Rate Estimator - Quote/Invoice", ln=True, align='C')

    # Client and Property Information
    pdf.set_font("Arial", size=10)
    pdf.cell(200, 10, txt="Client and Property Information", ln=True, align='L')
    for key, value in client_info.items():
        pdf.cell(200, 10, txt=f"{key}: {value}", ln=True, align='L')
    
    # Premiums
    pdf.cell(200, 10, txt="Premiums", ln=True, align='L')
    for key, value in premium_inputs.items():
        pdf.cell(200, 10, txt=f"{key.replace('_', ' ').title()}: ${value}", ln=True, align='L')
    
    total_premium = sum(premium_inputs.values())
    pdf.cell(200, 10, txt=f"Total Premium: ${total_premium}", ln=True, align='L')
    
    # Scheduled Items
    pdf.cell(200, 10, txt="Scheduled Items", ln=True, align='L')
    for key, value in scheduled_items.items():
        pdf.cell(200, 10, txt=f"{key}: ${value}", ln=True, align='L')
    
    # Notes
    pdf.cell(200, 10, txt="Notes", ln=True, align='L')
    pdf.multi_cell(0, 10, notes)
    
    return pdf.output(dest='S').encode('latin1')

def app():
    st.title("Lloyd Standard Rate Estimator")

    # Initial dummy data
    if 'premium_inputs' not in st.session_state:
        st.session_state['premium_inputs'] = {
            'dwelling_premium': 1000,
            'eq_dwelling_premium': 200,
            'eq_dps_premium': 150,
            'eq_contents_premium': 100,
            'eq_ale_premium': 50,
            'liability_extension': 300,
            'additional_premium': 200,
            'discretionary_discount': 0
        }
    
    premium_inputs = st.session_state['premium_inputs']
    total_premium = sum(premium_inputs.values())

    # Client and Property Information
    client_info = {
        'Client': 'John Doe',
        'Address': '123 Main St',
        'Postal Code': '12345',
        'Year Dwelling Built': 2000,
        'Number of Storeys': 2,
        'Age': 45,
        'Client Code': 'JD123',
        'Agency': 'Best Agency',
        'Occupancy': 'Primary',
        'Location Factor': 'None',
        'Fire Protection': 'Table 1'
    }

    # Scheduled Items
    scheduled_items = {
        "Jewellery": 10000,
        "Fine Arts": 5000,
        "Furs": 3000,
        "Camera": 2000,
        "Musical Instruments": 1000,
        "Stamps/Coins/Collectibles": 800,
        "Hearing Aids": 600,
        "Bicycle": 400
    }

    notes = "This is a note."

    # Generate PDF
    pdf_data = create_pdf(premium_inputs, client_info, scheduled_items, notes)
    b64_pdf = base64.b64encode(pdf_data).decode('latin1')
    href = f'<a href="data:application/octet-stream;base64,{b64_pdf}" download="quote_invoice.pdf">Download Quote/Invoice</a>'
    
    st.markdown(href, unsafe_allow_html=True)

    # Display total premium dynamically at the top
    st.header(f"Total Premium: ${total_premium}")

    # Client and Property Information Section
    st.header("Client and Property Information")
    col1, col2 = st.columns(2)
    
    with col1:
        dwelling_limit = st.number_input("Dwelling Limit", value=500000)
        detached_private_structures_limit = st.number_input("Detached Private Structures Limit", value=50000)
        contents_limit = st.number_input("Contents Limit", value=100000)
        additional_living_expenses_limit = st.number_input("Additional Living Expenses Limit", value=20000)
        client = st.text_input("Client", value="John Doe")
        address = st.text_input("Address", value="123 Main St")
        postal_code = st.text_input("Postal Code", value="12345")
        year_built = st.number_input("Year Dwelling Built", value=2000)
    
    with col2:
        number_of_storeys = st.number_input("Number of Storeys", value=2)
        age = st.number_input("Age", value=45)
        client_code = st.text_input("Client Code", value="JD123")
        agency = st.text_input("Agency", value="Best Agency")
        occupancy = st.selectbox("Occupancy", ["Primary", "Seasonal", "Secondary"], index=0)
        location_factor = st.selectbox("Location Factor", ["None", "Out of Area", "Other"], index=0)
        fire_protection = st.selectbox("Fire Protection", ["Table 1", "Table 2"], index=0)

    # Surcharges Section
    st.header("Surcharges")
    col3, col4 = st.columns(2)
    with col3:
        wood_heat_surcharge = st.checkbox("Wood Heat Surcharge")
    with col4:
        multi_family_surcharge = st.checkbox("Multi Family Surcharge")
    
    # Discounts Section
    st.header("Discounts")
    col5, col6 = st.columns(2)
    with col5:
        age_discount = st.radio("Age Discount", ["None", "Mature 50+", "Senior 60+"], horizontal=True)
        new_home_discount = st.checkbox("New Home Discount")
        claims_free_years = st.radio("Claims Free Years", ["None", "3 to 4", "5 to 9", "10+"], horizontal=True)
    with col6:
        alarm_discount = st.radio("Alarm Discount", ["None", "Local", "Monitored"], horizontal=True)
        mortgage_free_discount = st.checkbox("Mortgage Free Discount")
        loyalty_discount = st.radio("Loyalty Discount", ["None", "5%", "10%"], horizontal=True)
        policy_deductible = st.radio("Policy Deductible", ["1,000", "2,000", "3,000", "4,000", "5,000"], horizontal=True)
        reduced_contents_discount = st.radio("Reduced Contents Discount", ["80% Std", "70%", "60%", "50%", "40%"], horizontal=True)
    
    # Earthquake Coverage Section
    st.header("Earthquake Coverage")
    earthquake_coverage = st.radio("Earthquake Coverage", ["No EQ Deductible", "15% Deductible"], horizontal=True)
    col7, col8 = st.columns(2)
    with col7:
        eq_dwelling = st.checkbox("Dwelling")
        eq_dps = st.checkbox("DPS")
    with col8:
        eq_contents = st.checkbox("Contents")
        eq_ale = st.checkbox("ALE")
    
    # Premiums Section
    st.header("Premiums")
    col9, col10 = st.columns(2)
    with col9:
        dwelling_premium = st.number_input("Dwelling Premium", value=premium_inputs['dwelling_premium'])
        eq_dwelling_premium = st.number_input("EQ Dwelling", value=premium_inputs['eq_dwelling_premium'])
        eq_dps_premium = st.number_input("EQ DPS", value=premium_inputs['eq_dps_premium'])
    with col10:
        eq_contents_premium = st.number_input("EQ Contents", value=premium_inputs['eq_contents_premium'])
        eq_ale_premium = st.number_input("EQ ALE", value=premium_inputs['eq_ale_premium'])
    
    # Scheduled Premium Total and Additional Premiums Section
    st.subheader("Scheduled Premium Total and Additional Premiums")
    col11, col12 = st.columns(2)
    with col11:
        liability_extension = st.number_input("Liability Extension", value=premium_inputs['liability_extension'])
    with col12:
        additional_premium = st.number_input("Add Premium", value=premium_inputs['additional_premium'])
    
    # Discretionary Discount
    discretionary_discount = st.slider("Discretionary Discount", min_value=0, max_value=100, value=premium_inputs['discretionary_discount'])

    # Update premium inputs
    premium_inputs['dwelling_premium'] = dwelling_premium
    premium_inputs['eq_dwelling_premium'] = eq_dwelling_premium
    premium_inputs['eq_dps_premium'] = eq_dps_premium
    premium_inputs['eq_contents_premium'] = eq_contents_premium
    premium_inputs['eq_ale_premium'] = eq_ale_premium
    premium_inputs['liability_extension'] = liability_extension
    premium_inputs['additional_premium'] = additional_premium
    premium_inputs['discretionary_discount'] = discretionary_discount

    # Calculate and display updated total premium
    total_premium = sum(premium_inputs.values())
    st.header(f"Updated Total Premium: ${total_premium}")

    # Scheduled Items Section
    st.header("Scheduled Items")
    scheduled_items = {
        "Jewellery": st.number_input("Jewellery", value=10000),
        "Fine Arts": st.number_input("Fine Arts", value=5000),
        "Furs": st.number_input("Furs", value=3000),
        "Camera": st.number_input("Camera", value=2000),
        "Musical Instruments": st.number_input("Musical Instruments", value=1000),
        "Stamps/Coins/Collectibles": st.number_input("Stamps/Coins/Collectibles", value=800),
        "Hearing Aids": st.number_input("Hearing Aids", value=600),
        "Bicycle": st.number_input("Bicycle", value=400)
    }
    
    # Notes Section
    st.header("Notes")
    notes = st.text_area("Notes", value="This is a note.")


    pdf_data = create_pdf(premium_inputs, client_info, scheduled_items, notes)
    b64_pdf = base64.b64encode(pdf_data).decode('latin1')
    href = f'<a href="data:application/octet-stream;base64,{b64_pdf}" download="quote_invoice.pdf">Download Quote/Invoice</a>'
    
    st.markdown(href, unsafe_allow_html=True)
# Button to download the PDF
    if st.button("Prepare PDF"):
        pdf = create_pdf(premium_inputs, client_info, scheduled_items, notes)
        # b64_pdf = base64.b64encode(pdf).decode('latin1')
        # pdf_link = f'<a href="data:application/octet-stream;base64,{b64_pdf}" download="quote_invoice.pdf">Download Quote/Invoice PDF</a>'
        # st.markdown(pdf_link, unsafe_allow_html=True)
        st.download_button(
            label="Download PDF",
            data=pdf,
            file_name="quote_invoice.pdf",
            mime="application/pdf"
        )
