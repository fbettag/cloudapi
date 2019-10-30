defmodule CloudAPI.Client do
  @moduledoc """
  This client takes care of communication with a Joyent Triton cluster via CloudAPI HTTP REST calls.
  """

  use HTTPoison.Base

  def run(full_cmd) do
    System.cmd("/bin/sh", ["-c", full_cmd])
  end

  def auth_headers(dc = %CloudAPI.Datacenter{}) do
    date_cmd = "date -u '+%a, %d %h %Y %H:%M:%S GMT' | tr -d '\n'"
    {date, _} = run date_cmd
    {signature, _} = run "#{date_cmd} | openssl dgst -sha256 -sign #{dc.keyfile} | openssl enc -e -a | tr -d '\n'"

    [
      "Accept": "application/json",
      "Accept-Version": "~8",
      "Date": date,
      "Authorization": "Signature keyId=\"/#{dc.account}/keys/#{dc.keyname}\",algorithm=\"rsa-sha256\" #{signature}"
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
