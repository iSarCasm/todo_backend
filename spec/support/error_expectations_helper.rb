module ErrorExpectations
  def expect_http_error(error)
    expect(response.status).to eq error
    expect(json).to include 'errors'
  end
end
