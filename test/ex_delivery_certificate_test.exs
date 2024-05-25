defmodule ExDeliveryCertificateTest do
  use ExUnit.Case
  doctest ExDeliveryCertificate

  alias ExDeliveryCertificate
  alias ExDeliveryCertificate.CertificateData


  def test_data() do
    CertificateData.new()
    |> CertificateData.add_sender_name("sender")
    |> CertificateData.add_receiver_name("receiver")
    |> CertificateData.add_document_hash("hash")
    |> CertificateData.add_delivery_date(DateTime.utc_now() |> DateTime.to_iso8601())
    |> CertificateData.add_delivery_provider("provider")
  end

  test "issue_certificate" do
    {pem_key, pem_cert} = generate_dummy_cert()
    ExDeliveryCertificate.issue_certificate(test_data(), pem_key, pem_cert)
  end

  test "validate_certificate" do
    xml_string = File.read!("test/files/test_cert.xml")
    assert {:ok,
    %ExDeliveryCertificate.CertificateData{
      delivery_date: "2024-05-25T20:29:00.218258Z",
      delivery_provider: "provider",
      document_hash: "hash",
      receiver_name: "receiver",
      sender_name: "sender"
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

    pem_key = X509.PrivateKey.to_pem(my_key)
    pem_cert = X509.Certificate.to_pem(my_cert)

    {pem_key, pem_cert}
  end

  def private_key_from_pem(pem) do
    X509.PrivateKey.from_pem(pem)
  end
end
