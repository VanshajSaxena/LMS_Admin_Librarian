import SwiftUI

struct AddCampaignEventsSheetView: View {
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @State private var campaignDetails: String = ""
    @ObservedObject var viewModel : AddCampaignEventsViewModel

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Campaign")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(10)
                    TextField("Enter the Name of the Campaign", text: $viewModel.title)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Price")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Slider(value: $viewModel.price, in: 0...10000, step: 1)
                    Text("\(Int(viewModel.price))")
                        .font(.footnote)
                        .foregroundColor(.gray)
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

                            //Spacer()

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

                                //Spacer()

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
                        .onChange(of: viewModel.description) { newValue, perform in
                        }
                }
                .padding(20)

                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.addCampaign()
                    }) {
                        Text("Send Request")
                            .padding()
                            .frame(maxWidth: 150, alignment: .center)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity) // Make sure the content takes full width
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure proper navigation style for iPads
    }
}

struct AddCampaignView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCampaignEventsSheetView(viewModel: AddCampaignEventsViewModel.sample)
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
            AddCampaignEventsSheetView(viewModel: AddCampaignEventsViewModel.sample)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
