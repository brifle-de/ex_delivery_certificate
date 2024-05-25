defmodule ExDeliveryCertificate.CertificateData do
  defstruct [
    :sender_name,
    :receiver_name,
    :document_hash, # sha256 hash of the document
    :delivery_date,
    :delivery_provider,
  ]

  @doc """
  Create a new CertificateDate struct with the given provider.
  """
  def new(provider \\ ExDeliveryCertificate.CertificateConfig.default_provider()) do
    %__MODULE__{
      delivery_provider: provider
    }
  end

  @doc """
  Add the sender name to the CertificateDate struct.
  """
  def add_sender_name(data, sender_name) do
    %{data | sender_name: sender_name}
  end

  @doc """
  Add the receiver name to the CertificateDate struct.
  """
  def add_receiver_name(data, receiver_name) do
    %{data | receiver_name: receiver_name}
  end


  @doc """
  Add the document hash to the CertificateDate struct.
  """
  def add_document_hash(data, document_hash) do
    %{data | document_hash: document_hash}
  end

  @doc """
  Add the delivery date to the CertificateDate struct.
  """
  def add_delivery_date(data, delivery_date) do
    %{data | delivery_date: delivery_date}
  end

  @doc """
  Add the delivery provider to the CertificateDate struct.
  """
  def add_delivery_provider(data, delivery_provider) do
    %{data | delivery_provider: delivery_provider}
  end

  @doc """
  Convert the CertificateDate struct to a JSON string.
  """
  def to_json(%__MODULE__{} = data) do
    data
    |> Map.from_struct()
    |> Jason.encode!()
  end

  @doc """
  Convert a JSON string to a CertificateDate struct.
  """
  def from_json(json) do
    values = Jason.decode!(json)
    |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
    struct(__MODULE__, values)
  end

end
