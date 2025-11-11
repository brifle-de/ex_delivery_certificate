defmodule ExDeliveryCertificate.CertificateDataTest do
  alias ExDeliveryCertificate.CertificateData

  use ExUnit.Case


  test "add_document with map sets document_encoding to :json" do
    data = %CertificateData{}
    document = %{"type" => "application/pdf", "content" => "aGVsbG8gd29ybGQ="}
    updated_data = CertificateData.add_document(data, document)
    assert updated_data.document == document
    assert updated_data.document_encoding == :json
  end

  test "add_document with binary sets document_encoding to :base64" do
    data = %CertificateData{}
    document = "aGVsbG8gd29ybGQ="
    updated_data = CertificateData.add_document(data, document)
    assert updated_data.document == document
    assert updated_data.document_encoding == :base64
  end

  test "add_document with sha256 hash sets document_encoding to :sha256" do
    data = %CertificateData{}
    document = :crypto.hash(:sha256, "test document") |> Base.encode16(case: :lower)
    updated_data = CertificateData.add_document(data, document, :sha256)
    assert updated_data.document == document
    assert updated_data.document_encoding == :sha256
  end

  test "add_document with unsupported encoding raises ArgumentError" do
    data = %CertificateData{}
    document = "some document"
    assert_raise ArgumentError, fn ->
      CertificateData.add_document(data, document, :unsupported_encoding)
    end
  end

  test "to_json and from_json round trip" do
    original_data = %CertificateData{
      sender_name: "Alice",
      receiver_name: "Bob",
      tenant_id: "tenant_123",
      receiver_id: "receiver_456",
      document: %{"type" => "application/pdf", "content" => "aGVsbG8gd29ybGQ="},
      document_encoding: :json,
      request_data: %{"request" => "data"},
      action_metadata: %{"action" => "metadata"},
      delivery_date: "2024-10-18T21:37:14Z",
      delivery_provider: "provider_xyz"
    }

    json_string = CertificateData.to_json(original_data)
    parsed_data = CertificateData.from_json(json_string)

    assert parsed_data == original_data
    assert parsed_data.document == original_data.document
    assert parsed_data.request_data == original_data.request_data
    assert parsed_data.action_metadata == original_data.action_metadata
  end

  test "new/1 sets default delivery_provider" do
    data = CertificateData.new("CustomProvider")
    assert data.delivery_provider == "CustomProvider"
  end

  test "new/0 sets default delivery_provider from config" do
    default_provider = ExDeliveryCertificate.CertificateConfig.default_provider()
    data = CertificateData.new()
    assert data.delivery_provider == default_provider
  end

  test "add_sender_name/2 updates sender_name" do
    data = %CertificateData{}
    updated_data = CertificateData.add_sender_name(data, "New Sender")
    assert updated_data.sender_name == "New Sender"
  end

  test "add_receiver_name/2 updates receiver_name" do
    data = %CertificateData{}
    updated_data = CertificateData.add_receiver_name(data, "New Receiver")
    assert updated_data.receiver_name == "New Receiver"
  end

  test "add_delivery_date/2 updates delivery_date" do
    data = %CertificateData{}
    updated_data = CertificateData.add_delivery_date(data, "2024-10-18T21:37:14Z")
    assert updated_data.delivery_date == "2024-10-18T21:37:14Z"
  end

  test "add_delivery_provider/2 updates delivery_provider" do
    data = %CertificateData{}
    updated_data = CertificateData.add_delivery_provider(data, "New Provider")
    assert updated_data.delivery_provider == "New Provider"
  end

  test "add_tenant_id/2 updates tenant_id" do
    data = %CertificateData{}
    updated_data = CertificateData.add_tenant_id(data, "tenant_123")
    assert updated_data.tenant_id == "tenant_123"
  end

  test "add_request_data/2 updates request_data" do
    data = %CertificateData{}
    updated_data = CertificateData.add_request_data(data, %{"key" => "value"})
    assert updated_data.request_data == %{"key" => "value"}
  end

  test "add_action_metadata/2 updates action_metadata" do
    data = %CertificateData{}
    updated_data = CertificateData.add_action_metadata(data, %{"meta" => "data"})
    assert updated_data.action_metadata == %{"meta" => "data"}
  end

  test "add_receiver_id/2 updates receiver_id" do
    data = %CertificateData{}
    updated_data = CertificateData.add_receiver_id(data, "receiver_456")
    assert updated_data.receiver_id == "receiver_456"
  end




end
