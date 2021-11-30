require 'oreilly_api'
require 'rest-client'
require 'spec_helper'

# rubocop:disable Metrics/BlockLength
# rubocop:disable Layout/LineLength

RSpec.describe OreillyApi do
  let(:orielly_api) { OreillyApi }
  let(:token) { '9df2c226-9353-41ed-927e-73dc2df11304' }
  let(:token_response) do
    { "access_token" => token, "token_type" => "bearer", "expires_in" => 119, "scope" => "sms_external", "active" => true,
      "authorities" => %w[ROLE_SMS_PLACE_ORDER ROLE_SMS_READ_QUOTE] }.to_json
  end
  let(:sample_request) do
    { "header" => { "identity" => "identity to be provided", "payloadId" => "YM12345620181112060410",
                    "timestamp" => "2018-11-12 06:04:10" }, "accountNumber" => "123456", "items" => [{ "lineId" => 1, "mfgCode" => "MGD", "partNumber" => "MGA42188", "quantity" => 2, "kitId" => 0 }, { "lineId" => 2, "mfgCode" => "GAT", "partNumber" => "K070683", "quantity" => 1, "kitId" => 0 }, { "lineId" => 3, "mfgCode" => "WIX", "partNumber" => "51515", "quantity" => 10, "kitId" => 0 }, { "lineId" => 4, "mfgCode" => "KAN", "partNumber" => "PS2009", "quantity" => 20, "kitId" => 0 }, { "lineId" => 5, "mfgCode" => "GAT", "partNumber" => "K070683", "quantity" => 1, "kitId" => 0 }, { "lineId" => 6, "mfgCode" => "BB", "partNumber" => "SM473", "quantity" => 1, "kitId" => 1 }, { "lineId" => 7, "mfgCode" => "BBR", "partNumber" => "6131RGS", "quantity" => 2, "kitId" => 1 }] }.to_json
  end
  let(:sample_order) do
    {
      "header" => { "identity" => "identity to be provided", "payloadId" => "YM12345620181112060410",
                    "timestamp" => "2018-11-12 06:04:10" }, "orderHeader" => { "poNumber" => "SMSPONum", "accountNumber" => "123456", "comments" => "test" }, "vehicles" => [{ "vehicleId" => "5260", "year" => "2002", "make" => "Honda", "model" => "CR-V", "engine" => "Engine: L4 - 2.4L 2351cc GAS MFI", "items" => [{ "lineId" => "1", "mfgCode" => "WIX", "partNumber" => "51515", "quantity" => "10", "comments" => "test comments" }, { "lineId" => "2", "mfgCode" => "GAT", "partNumber" => "K07068", "quantity" => "10", "comments" => "test comments" }, { "lineId" => "3", "mfgCode" => "FRA", "partNumber" => "PH8A", "quantity" => "10", "comments" => "test comments" }, { "lineId" => "4", "mfgCode" => "MGD", "partNumber" => "MGA460778", "quantity" => "10", "comments" => "test comments" }, { "lineId" => "5", "mfgCode" => "WIX", "partNumber" => "46077", "quantity" => "10", "comments" => "test comments" }] }]
    }.to_json
  end
  let(:sample_invoice) {}
  let(:sample_quote) do
    {
      "header" => { "identity" => "IDENTITY", "payloadId" => "YM12345620181112060410",
                    "timestamp" => "2021-11-26 06:49:30" }, "accountNumber" => "123456", "details" => [{ "lineId" => 1, "kitId" => 0, "mfgCode" => "MGD", "partNumber" => "MGA42188", "quantity" => 1, "comments" => nil, "listPrice" => 2.86, "cost" => 1.69, "coreCharge" => 0.0, "unitOfMeasure" => "Each", "warrantyDesc" => nil, "description" => nil, "locations" => [{ "locationNumber" => 4031, "locationDescription" => "STR", "locationName" => "SPRINGFIELD MO 4031", "locationAddr1" => nil, "locationAddr2" => "721 NORTH GLENSTONE AVE", "locationCity" => "SPRINGFIELD", "locationState" => "MO", "locationZip" => "658022117", "locationCounty" => "GREENE", "locationPhoneNumber" => "417-862-1911", "locationQuantity" => 1 }] }]
    }.to_json
  end
  let(:base_url) { 'https://sms-test-1.firstcallonline.com/sms-external-partner/services' }

  before :all do
    OreillyApi.config do |c|
      c.domain = 'https://sms-test-1.firstcallonline.com'
      c.client_id = 'client_id'
      c.client_secret = 'client_sercet'
      c.identity = 'IDENTITY'
      c.version = 'sms-external-partner/services'
      c.account_number = '123456'
      c.redis_utility = { host: "127.0.0.1", timeout: 60, db: 1, password: nil }
    end
  end

  it "has a version number" do
    expect(OreillyApi::VERSION).not_to be nil
  end

  it '.sample_request' do
    allow(OreillyApi).to receive(:fetch_token).and_return(200, token_response)
    stub_request(:get, "#{base_url}/quote/sampleRequest?detailsRequired=false").to_return(
      status: 200, body: sample_request, headers: {}
    )
    res_code, response = orielly_api.sample_request
    expect(res_code).to eq(200)
    expect(response.to_json).to eq(sample_request)
  end

  it '.test_place_order' do
    allow(OreillyApi).to receive(:fetch_token).and_return(200, token_response)
    stub_request(:get, "#{base_url}/order/testPlaceOrder?detailsRequired=false").to_return(
      status: 200, body: sample_order, headers: {}
    )
    res_code, response = orielly_api.test_place_order
    expect(res_code).to eq(200)
    expect(response.to_json).to eq(sample_order)
  end

  xit '.invoice' do
    allow(OreillyApi).to receive(:fetch_token).and_return(200, token_response)
    stub_request(:get, "#{base_url}/order/invoice?identity=IDENTITY&orderDetails=true&orderNumber=YMGRJWJDBQ").to_return(
      status: 200, body: sample_invoice, headers: {}
    )
    res_code, response = orielly_api.invoice
    expect(res_code).to eq(200)
    expect(response.to_json).to eq(sample_invoice)
  end

  it 'should get a quote' do
    allow(OreillyApi).to receive(:fetch_token).and_return(200, token_response)
    stub_request(:post, "#{base_url}/quote/fetchQuote")
      .to_return(status: 200, body: sample_quote, headers: {})
    items = [{
      'lineId' => 1,
      'mfgCode' => 'MGD',
      'partNumber' => 'MGA42188',
      'quantity' => 1,
      'kitId' => 0
    }]
    res_code, response = orielly_api.fetch_quote(items)
    expect(res_code).to eq(200)
    expect(response.to_json).to eq(sample_quote)
  end

  it 'should place an order' do
    allow(OreillyApi).to receive(:fetch_token).and_return(200, token_response)
    stub_request(:post, "#{base_url}/order/placeOrder?stopOrder=false")
      .to_return(status: 200, body: sample_order, headers: {})

    vehicles_with_items = [
      {
        'vehicleId' => '5260',
        'year' => '2002',
        'make' => 'Honda',
        'model' => 'CR-V',
        'engine' => 'Engine: L4 - 2.4L 2351cc GAS MFI',
        'items' => [
          {
            'lineId' => 1,
            'mfgCode' => 'WIX',
            'partNumber' => '51515',
            'quantity' => 10,
            'comments' => 'test comments'
          }
        ]
      }
    ]
    res_code, response = orielly_api.place_order("po_number", vehicles_with_items)
    expect(res_code).to eq(200)
    expect(response.to_json).to eq(sample_order)
  end
  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Layout/LineLength
end
