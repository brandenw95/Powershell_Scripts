import streamlit as st
from fpdf import FPDF
import base64

# Function to create PDF
def create_pdf(client_info, surcharges, discounts, premiums, scheduled_items, notes):
    pdf = FPDF()
    pdf.add_page()
    
    # Title
    pdf.set_font("Arial", size=12)
    pdf.cell(200, 10, txt="Standard Farm Rater - Quote/Invoice", ln=True, align='C')

    # Client and Property Information
    pdf.set_font("Arial", size=10)
    pdf.cell(200, 10, txt="Client and Property Information", ln=True, align='L')
    for key, value in client_info.items():
        pdf.cell(200, 10, txt=f"{key}: {value}", ln=True, align='L')
    
    # Surcharges
    pdf.cell(200, 10, txt="Surcharges", ln=True, align='L')
    for key, value in surcharges.items():
        pdf.cell(200, 10, txt=f"{key.replace('_', ' ').title()}: ${value}", ln=True, align='L')

    # Discounts
    pdf.cell(200, 10, txt="Discounts", ln=True, align='L')
    for key, value in discounts.items():
        pdf.cell(200, 10, txt=f"{key.replace('_', ' ').title()}: ${value}", ln=True, align='L')
    
    # Premiums
    pdf.cell(200, 10, txt="Premiums", ln=True, align='L')
    for key, value in premiums.items():
        pdf.cell(200, 10, txt=f"{key.replace('_', ' ').title()}: ${value}", ln=True, align='L')
    
    total_premium = sum(premiums.values())
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
    st.title("Standard Farm Rater")

    # Dummy data for demonstration
    if 'client_info' not in st.session_state:
        st.session_state['client_info'] = {
            'Client': 'Jane Smith',
            'Address': '456 Farm Road',
            'Postal Code': '67890',
            'Year Dwelling Built': 1995,
            'Number of Storeys': 1,
            'Age': 50,
            'Client Code': 'JS456',
            'Agency': 'Farm Agency',
            'Occupancy': 'Primary',
            'Location Factor': 'None',
            'Fire Protection': 'Table 1'
        }

    if 'surcharges' not in st.session_state:
        st.session_state['surcharges'] = {
            'wood_heat_surcharge': 0,
            'multi_family_surcharge': 0
        }

    if 'discounts' not in st.session_state:
        st.session_state['discounts'] = {
            'age_discount': 0,
            'new_home_discount': 0,
            'claims_free_discount': 0,
            'alarm_discount': 0,
            'mortgage_free_discount': 0,
            'loyalty_discount': 0,
            'policy_deductible_discount': 0,
            'reduced_contents_discount': 0
        }

    if 'premiums' not in st.session_state:
        st.session_state['premiums'] = {
            'dwelling_premium': 1200,
            'eq_dwelling_premium': 250,
            'eq_dps_premium': 175,
            'eq_contents_premium': 125,
            'eq_ale_premium': 75,
            'liability_extension': 350,
            'additional_premium': 250,
            'discretionary_discount': 0
        }

    if 'scheduled_items' not in st.session_state:
        st.session_state['scheduled_items'] = {
            "Jewellery": 15000,
            "Fine Arts - no Breakage": 8000,
            "Fine Arts - with breakage": 3000,
            "Furs up to $10,000": 2000,
            "Camera": 2500,
            "Bicycle ($100 deductible)": 500,
            "Music Instruments": 1500,
            "Hearing Aids ($100 deductible)": 700
        }

    client_info = st.session_state['client_info']
    surcharges = st.session_state['surcharges']
    discounts = st.session_state['discounts']
    premiums = st.session_state['premiums']
    scheduled_items = st.session_state['scheduled_items']

    total_premium = sum(premiums.values())

    # Display total premium dynamically at the top
    st.header(f"Total Premium: ${total_premium}")

    # Client and Property Information Section
    st.header("Client and Property Information")
    col1, col2 = st.columns(2)
    

    
    with col1:
        client_info['dwelling_limit'] = st.number_input("Dwelling Limit", value=500000)
        client_info['detached_private_structures_limit'] = st.number_input("Detached Private Structures Limit", value=60000)
        client_info['contents_limit'] = st.number_input("Contents Limit", value=120000)
        client_info['additional_living_expenses_limit'] = st.number_input("Additional Living Expenses Limit", value=25000)
        client_info['client'] = st.text_input("Client", value="Jane Smith")
        client_info['address'] = st.text_input("Address", value="456 Farm Road")
        client_info['postal_code'] = st.text_input("Postal Code", value="67890")
        client_info['year_built'] = st.number_input("Year Dwelling Built", value=1995)
    
    with col2:
        client_info['number_of_storeys'] = st.number_input("Number of Storeys", value=1)
        client_info['age'] = st.number_input("Age", value=50)
        client_info['client_code'] = st.text_input("Client Code", value="JS456")
        client_info['agency'] = st.text_input("Agency", value="Farm Agency")
        client_info['occupancy'] = st.selectbox("Occupancy", ["Primary", "Seasonal", "Secondary"], index=0)
        client_info['location_factor'] = st.selectbox("Location Factor", ["None", "Out of Area", "Other"], index=0)
        client_info['fire_protection'] = st.selectbox("Fire Protection", ["Table 1", "Table 2", "Table 3"], index=0)

    # Surcharges Section
    st.header("Surcharges")
    col3, col4 = st.columns(2)
    with col3:
        surcharges['wood_heat_surcharge'] = st.checkbox("Wood Heat Surcharge")
    with col4:
        surcharges['multi_family_surcharge'] = st.radio("Multi Family Surcharge", ["None", "2 - 3 Families", "4 Family"], horizontal=True)
    
    # Discounts Section
    st.header("Discounts")
    col5, col6 = st.columns(2)
    with col5:
        discounts['age_discount'] = st.radio("Age Discount", ["None", "45 - 49", "50 - 59", "60+"], horizontal=True)
        discounts['new_home_discount'] = st.checkbox("New Home Discount")
        discounts['claims_free_discount'] = st.radio("Claims Free Years", ["None", "3 to 4", "5 to 9", "10+"], horizontal=True)
    with col6:
        discounts['alarm_discount'] = st.radio("Alarm Discount", ["None", "Local", "Monitored"], horizontal=True)
        discounts['mortgage_free_discount'] = st.radio("Mortgage Free Discount", ["None", "Secured Line of Credit", "Mortgage Free"], horizontal=True)
        discounts['loyalty_discount'] = st.radio("Loyalty Discount", ["None", "5%", "10%"], horizontal=True)
        discounts['policy_deductible_discount'] = st.radio("Policy Deductible", ["1,000", "2,000", "3,000", "4,000", "5,000"], horizontal=True)
        discounts['reduced_contents_discount'] = st.radio("Reduced Contents Discount", ["80% Std", "70%", "60%", "50%", "40%"], horizontal=True)
    
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
        premiums['dwelling_premium'] = st.number_input("Dwelling Premium", value=1200)
        premiums['eq_dwelling_premium'] = st.number_input("EQ Dwelling", value=250)
        premiums['eq_dps_premium'] = st.number_input("EQ DPS", value=175)
        premiums['eq_contents_premium'] = st.number_input("EQ Contents", value=125)
        premiums['eq_ale_premium'] = st.number_input("EQ ALE", value=75)
        eq_sub_limit = st.radio("OLW", ["None", "$25,000", "$50,000", "$100,000", "$250,000", "$500,000"], horizontal=True)
    with col10:
        water_service_line = st.checkbox("Water Service Line")
        water_deductible = st.checkbox("Water Deductible Buy Down")
        water_deductible_value = st.number_input("Water Deductible: ", value=2000)
        premiums['liability_extension'] = st.number_input("Liability Extension", value=350)
        premiums['additional_premium'] = st.number_input("Add Premium", value=250)
        premiums['discretionary_discount'] = st.number_input("Discretionary Discount", value=0)

    # Calculate and display updated total premium
    total_premium = sum(premiums.values())
    st.header(f"Updated Total Premium: ${total_premium}")

    # Scheduled Items Section
    st.header("Scheduled Items")
    scheduled_items['Jewellery'] = st.number_input("Jewellery", value=15000)
    scheduled_items['Fine Arts - no Breakage'] = st.number_input("Fine Arts - no Breakage", value=8000)
    scheduled_items['Fine Arts - with breakage'] = st.number_input("Fine Arts - with breakage", value=3000)
    scheduled_items['Furs up to $10,000'] = st.number_input("Furs up to $10,000", value=2000)
    scheduled_items['Camera'] = st.number_input("Camera", value=2500)
    scheduled_items['Bicycle ($100 deductible)'] = st.number_input("Bicycle ($100 deductible)", value=500)
    scheduled_items['Music Instruments'] = st.number_input("Music Instruments", value=1500)
    scheduled_items['Hearing Aids ($100 deductible)'] = st.number_input("Hearing Aids ($100 deductible)", value=700)

    # Notes Section
    st.header("Notes")
    notes = st.text_area("Notes", value="This is a note.")
    
    # Button to download the PDF
    if st.button("Prepare PDF"):
        pdf = create_pdf(client_info, surcharges, discounts, premiums, scheduled_items, notes)

        st.download_button(
            label="Download PDF",
            data=pdf,
            file_name="quote_invoice.pdf",
            mime="application/pdf"
        )

