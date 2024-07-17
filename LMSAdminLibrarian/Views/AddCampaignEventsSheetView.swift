import SwiftUI

struct AddCampaignEventsSheetView: View {
    @ObservedObject var viewModel: AddCampaignEventsViewModel
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    // Validation error states
    @State private var titleError: String?
    @State private var priceError: String?
    @State private var typeError: String?
    @State private var startDateError: String?
    @State private var endDateError: String?
    @State private var descriptionError: String?

    var body: some View {
        ScrollView {
         
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Campaign")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Type")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    HStack {
                        Button(action: {
                            viewModel.type = "event"
                        }) {
                            Text("Event")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.type == "event" ? Color.themeOrange : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            viewModel.type = "sale"
                        }) {
                            Text("Sale")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.type == "sale" ? Color.themeOrange : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    if let typeError = typeError {
                        Text(typeError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(10)
                    TextField("Enter the Name of the Campaign", text: $viewModel.title)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                    if let titleError = titleError {
                        Text(titleError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Ticket Price")
                        .font(.headline)
                        .foregroundColor(.orange)
                    TextField("Enter the Ticket Price", text: $viewModel.price)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                    if let priceError = priceError {
                        Text(priceError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(20)

               

                VStack(alignment: .leading, spacing: 10) {
                    Text("Duration")
                        .font(.headline)
                        .foregroundColor(.orange)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Start Date")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 100, alignment: .leading)

                            Text(viewModel.startDate, style: .date)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.orange, lineWidth: 1))
                                .onTapGesture {
                                    self.showStartDatePicker.toggle()
                                }
                                .popover(isPresented: $showStartDatePicker) {
                                    DatePicker("Select Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .frame(width: 300, height: 300)
                                        .padding()
                                }
                        }

                        HStack {
                            Text("End Date")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 100, alignment: .leading)

                            Text(viewModel.endDate, style: .date)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.orange, lineWidth: 1))
                                .onTapGesture {
                                    self.showEndDatePicker.toggle()
                                }
                                .popover(isPresented: $showEndDatePicker) {
                                    DatePicker("Select End Date", selection: $viewModel.endDate, in: viewModel.startDate..., displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .frame(width: 300, height: 300)
                                        .padding()
                                }
                        }
                    }
                    if let startDateError = startDateError {
                        Text(startDateError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    if let endDateError = endDateError {
                        Text(endDateError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Details")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    TextEditor(text: $viewModel.description)
                        .frame(height: 200)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                    if let descriptionError = descriptionError {
                        Text(descriptionError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(20)

                HStack {
                    Spacer()
                    Button(action: {
                        if validateFields() {
                            viewModel.addCampaign()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Send Request")
                            .padding()
                            .frame(maxWidth: 150, alignment: .center)
                            .background(Color("ThemeOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Validation function
    private func validateFields() -> Bool {
        var isValid = true
        
        // Validate title
        if viewModel.title.isEmpty {
            titleError = "Title cannot be empty"
            isValid = false
        } else {
            titleError = nil
        }
        
        // Validate price
        if viewModel.price.isEmpty {
            priceError = "Price cannot be empty"
            isValid = false
        } else if let price = Double(viewModel.price), price < 0 {
            priceError = "Price cannot be negative"
            isValid = false
        } else {
            priceError = nil
        }
        
        // Validate type
        if viewModel.type.isEmpty {
            typeError = "Type must be selected"
            isValid = false
        } else {
            typeError = nil
        }
        
        // Validate start date
        if viewModel.startDate < Date() {
            startDateError = "Start date cannot be in the past"
            isValid = false
        } else {
            startDateError = nil
        }
        
        // Validate end date
        if viewModel.endDate <= viewModel.startDate {
            endDateError = "End date must be after start date"
            isValid = false
        } else {
            endDateError = nil
        }
        
        // Validate description
        if viewModel.description.isEmpty {
            descriptionError = "Description cannot be empty"
            isValid = false
        } else {
            descriptionError = nil
        }
        
        return isValid
    }
}
