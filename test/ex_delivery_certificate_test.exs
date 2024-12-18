defmodule ExDeliveryCertificateTest do
  use ExUnit.Case
  doctest ExDeliveryCertificate

  alias ExDeliveryCertificate
  alias ExDeliveryCertificate.CertificateData


  def test_data() do
    CertificateData.new()
    |> CertificateData.add_sender_name("sender")
    |> CertificateData.add_receiver_name("receiver")
    |> CertificateData.add_tenant_id("tenant_id")
    |> CertificateData.add_action_metadata(%{"signatures" => ["signature_data", "signature_data2"]})
    |> CertificateData.add_request_data(%{"request_data" => "data"})
    |> CertificateData.add_document(%{"type" => "application/pdf", "content" => "aGVsbG8gd29ybGQ="})
    |> CertificateData.add_delivery_date(DateTime.utc_now() |> DateTime.to_iso8601())
    |> CertificateData.add_delivery_provider("provider")
  end

  test "issued_certificate_json" do
    {pem_key, pem_cert} = generate_dummy_cert()
    data = File.read!("test/files/cert_data copy.json")
    certdata = CertificateData.from_json(data)

    {:ok, res} = ExDeliveryCertificate.issue_certificate(certdata, pem_key, pem_cert)

    File.write!("test/files/cert_data_result.xml", res)    
  end

  test "issue_certificate" do
    {pem_key, pem_cert} = generate_dummy_cert()
    {:ok, res} = ExDeliveryCertificate.issue_certificate(test_data(), pem_key, pem_cert)

    assert {:ok, cert } = ExDeliveryCertificate.validate_certificate(res)

    File.write!("test/files/test_cert-python.xml", res)


    assert cert.sender_name == "sender"
    assert cert.receiver_name == "receiver"
    assert cert.document == %{"content" => "aGVsbG8gd29ybGQ=", "type" => "application/pdf"}
    assert cert.delivery_provider == "provider"




  end

  test "validate_certificate" do
    xml_string = File.read!("test/files/test_cert.xml")
    assert {:ok,
    %ExDeliveryCertificate.CertificateData{
      delivery_date: "2024-10-18T21:37:14.083455Z",
      delivery_provider: "provider",
      document: %{"content" => "aGVsbG8gd29ybGQ=", "type" => "application/pdf"},
      receiver_name: "receiver",
      sender_name: "sender",
      request_data: %{"request_data" => "data"},
      tenant_id: "tenant_id"
    }} = ExDeliveryCertificate.validate_certificate(xml_string)

  end

  def generate_dummy_cert() do
    ca_key = X509.PrivateKey.new_ec(:secp256r1)
    ca = X509.Certificate.self_signed(ca_key,"/C=US/ST=CA/L=San Francisco/O=Acme/CN=ECDSA Root CA", template: :root_ca)

    my_key = X509.PrivateKey.new_ec(:secp256r1)
    my_cert = my_key |>

    X509.PublicKey.derive()
    |> X509.Certificate.new(
      "/C=US/ST=CA/L=San Francisco/O=Acme/CN=Sample",
      ca, ca_key,
      extensions: [
        subject_alt_name: X509.Certificate.Extension.subject_alt_name(["example.org", "www.example.org"])
      ]
    )
    File.write!("test/files/test-ca-python.pem", X509.Certificate.to_pem(ca))


    pem_key = X509.PrivateKey.to_pem(my_key)
    pem_cert = X509.Certificate.to_pem(my_cert)

    {pem_key, pem_cert}
  end

  def private_key_from_pem(pem) do
    X509.PrivateKey.from_pem(pem)
  end
end
