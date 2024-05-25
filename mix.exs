defmodule ExDeliveryCertificate.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_delivery_certificate,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xml_builder, "~> 2.2"},
      {:xmerl_c14n, "~> 0.2.0"},
      {:x509, "~> 0.8.8"},
      {:sweet_xml, "~> 0.7.4"},
        # own library for create xml based signatures
      {:ex_crypto_sign, git: "git@github.com:brifle-de/ex_crypto_sign.git", tag: "v0.2.4"},

      {:jason, "~> 1.4.1"},
    ]
  end
end
