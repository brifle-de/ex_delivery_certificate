defmodule ExDeliveryCertificate.CertificateConfig do
  def delivery_certificate(), do: Application.get_env(:ex_delivery_certificate, :delivery_certificate, [])

  def default_provider(), do: delivery_certificate() |> Keyword.get(:default_provider, "Brifle")
end
