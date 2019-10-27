defmodule CloudAPI.Client do
  @moduledoc """
  This client takes care of communication with a Joyent Triton cluster via CloudAPI HTTP REST calls.
  """

  use HTTPoison.Base

  def process_url(url) do
    endpoint = Application.fetch_env!(:cloudapi, :endpoint)
    endpoint <> url
  end

  def run(full_cmd) do
    System.cmd("/bin/sh", ["-c", full_cmd])
  end

  def generate_auth_header() do
    keyfile = Application.fetch_env!(:cloudapi, :keyfile)
    date_cmd = "date -u '+%a, %d %h %Y %H:%M:%S GMT' | tr -d '\n'"
    {now, _} = run date_cmd
    {signature, _} = run "#{date_cmd} | openssl dgst -sha256 -sign #{keyfile} | openssl enc -e -a | tr -d '\n'"
    {now, signature}
  end

  def process_request_headers(headers) do
    account = Application.fetch_env!(:cloudapi, :account)
    keyname = Application.fetch_env!(:cloudapi, :keyname)
    {date, signature} = generate_auth_header()
    headers ++ [
      "Accept": "application/json",
      "Accept-Version": "~8",
      "Date": date,
      "Authorization": "Signature keyId=\"/#{account}/keys/#{keyname}\",algorithm=\"rsa-sha256\" #{signature}"
    ]
  end

  def response_as(response = {_, %HTTPoison.Response{}}, as \\ [keys: :atoms]) do
    case response do
      {:ok, %{status_code: 204, body: body}} ->
        {:ok, Poison.decode!(body, as)}
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body, as)}
      {_, %{body: body}} ->
        {:error, Poison.decode!(body, keys: :atoms)}
    end
  end
end
