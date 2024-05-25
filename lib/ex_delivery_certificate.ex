defmodule ExDeliveryCertificate do
  @moduledoc """
  Documentation for `ExDeliveryCertificate`.
  """

  alias ExCryptoSign.XmlDocument
  alias ExDeliveryCertificate.CertificateData

  defp get_ops(cert_pem) do

    signing_time = DateTime.utc_now() |> DateTime.to_iso8601()

    [
      signature_properties: %{
        signing_time: signing_time,
        signing_certificate: %{
          issuer: ExCryptoSign.Util.PemCertificate.get_certificate_issuer(cert_pem),
          serial: ExCryptoSign.Util.PemCertificate.get_certificate_serial(cert_pem),
          digest_type: :sha256,
          digest: ExCryptoSign.Util.PemCertificate.get_certificate_digest(cert_pem, :sha256)
        },
        signature_production_place: %{
          city_name: "Stuttgart",
          country: "Germany"
        },
        signer_role: %{
          claimed_roles: ["Delivery Provider", "Brifle"]
        }
      },
      signed_data_object_properties: %{
        data_object_format: [
          %{
          mime_type: "application/json",
          encoding: "UTF-8",
          description: "The data for proof of delivery",
          object_reference: "#doc-1"
        },
      ]
      },
      unsigned_signature_properties: %{

      }
    ]
  end


  def issue_certificate(%CertificateData{} = properties, private_pem, certificate_pem) do

    id = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
    data = CertificateData.to_json(properties)
    opts = get_ops(certificate_pem)
    xml_data = ExCryptoSign.prepare_raw_embedded(id, [%{id: "certificate_data", content: data}],certificate_pem,opts)
    {:ok, {xml_document_string, signature}} = ExCryptoSign.Util.Signer.sign(xml_data, private_pem)

    {:ok, xml_document_string}
  end

  def validate_certificate(xml_document_string) do
    case ExCryptoSign.Util.Verifier.verify_exported_signature(xml_document_string) do
      {:ok, true} ->
        content = get_certificate_content_from_signature(xml_document_string)
        {:ok, content}
       # {:ok, CertificateData.from_json()}
      _ -> {:error, "Signature is invalid"}
    end
  end

  defp get_certificate_content_from_signature(xml_signature) do
    doc = XmlDocument.parse_document(xml_signature)
    doc.embedded_documents
    |> Enum.find(fn %{id: id} -> id == "certificate_data" end)
    |> Map.get(:content)
    |> CertificateData.from_json()

  end





end
