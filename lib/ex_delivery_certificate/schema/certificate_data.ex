defmodule ExDeliveryCertificate.CertificateData do
  defstruct [
    :sender_name,
    :receiver_name,
    :tenant_id, # the tenant id of the sender
    :receiver_id, # the account id of the receiver
    :document, # json string document or base64 encoded document
    :request_data, # base64 encoded request data or json string
    :action_metadata, # base64 encoded or json string action metadata
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
  Add the given options to the CertificateDate struct.
  """
  def add(options) when is_map(options) do
    new() |> Map.merge(options)
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
  add the tenant id to the certificate data
  """
  def add_tenant_id(data, tenant_id) do
    %{data | tenant_id: tenant_id}
  end

  @doc """
  add the document to the certificate data
  """
  def add_document(data, document) do
    %{data | document: document}
  end

  @doc """
  add the request data to the certificate data
  """
  def add_request_data(data, request_data) do
    %{data | request_data: request_data}
  end

  @doc """
  add the action metadata to the certificate data
  """
  def add_action_metadata(data, action_metadata) do
    %{data | action_metadata: action_metadata}
  end

  @doc """
  add the receiver id to the certificate data
  """
  def add_receiver_id(data, receiver_id) do
    %{data | receiver_id: receiver_id}
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
