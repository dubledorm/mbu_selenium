require_relative '../../lib/functions/http_request'
require 'json'
require 'hash_at_path'


RSpec.describe Functions::HttpRequest do
  describe 'arguments' do
    context 'wrong_arguments' do
      it { expect(described_class.new({})).to_not be_valid }
      it { expect(described_class.new(url: 'https://name.ru', do: 'http_request', operation_id: 1)).to_not be_valid }
      it { expect(described_class.new(request_type: 'get', do: 'http_request', operation_id: 1)).to_not be_valid }
    end

    context 'truth arguments' do
      let(:url_examples) { %w[https://www.example.com
      http://www.example.com
      www.example.com
      example.com
      http://blog.example.com
      http://www.example.com/product
      http://www.example.com/products?id=1&page=2
      http://www.example.com#up
      http://255.255.255.255
      255.255.255.255
      http://www.site.com:8008] }


      it 'truth url' do
        url_examples.each do|url|
          expect(described_class.new( url: url,
                                      request_type: 'get',
                                      result_selector_json: '{"first_postamat_id":"/data/collection/[0]/id"}',
                                      do: 'http_request', operation_id: 1)).to be_valid
        end
      end
    end
  end

  describe 'done' do
    let(:example) { {
      "data": {
        "collection": [
          {
            "id": "637627623141d14a5523ef83",
            "number": "123-01",
            "url": "http://20.2.2.2:8080",
            "brandId": "63513f688e100ce3fab5b0a8",
            "description": "string11111",
            "dateCreate": "2022-11-17T12:21:54.772+00:00",
            "dateUpdate": "2022-11-29T07:34:43.045+00:00"
          },
          {
            "id": "63778ea9f423b1ba66167c6d",
            "number": "124-01",
            "url": "http://20.2.2.2:8080",
            "brandId": "63513f688e100ce3fab5b0a8",
            "description": "3et345t51",
            "dateCreate": "2022-11-18T13:54:49.96+00:00",
            "dateUpdate": "2022-11-29T07:34:43.1+00:00"
          },
        ],
        "pageSize": 20,
        "currentPage": 1,
        "pageCount": 1
      },
      "isSuccess": true,
      "error": nil
    } }

    context 'when status 200 and result has found' do
      let(:faraday_response) { Faraday::Response.new(status: 200, body: example.to_json) }
      let(:http_request1) { described_class.new( url: 'http://www.example.com',
                                                 request_type: 'get',
                                                 result_selector_json: { "first_postamat_id": "/data/collection/[0]/id" },
                                                 do: 'http_request', operation_id: 1,
                                                 storage: {}) }

      let(:http_request2) { described_class.new( url: 'http://www.example.com',
                                                 request_type: 'get',
                                                 only_response_200: 'true',
                                                 result_selector_json: { "first_postamat_id":"/data/collection/[*]/id" },
                                                 do: 'http_request', operation_id: 1,
                                                 storage: {}) }
      let(:http_request3) { described_class.new( url: 'http://www.example.com',
                                                 request_type: 'get',
                                                 only_response_200: 'true',
                                                 result_selector_json: { "first_postamat_id":"/data/collection/[1000]/id" },
                                                 do: 'http_request', operation_id: 1,
                                                 storage: {}) }



      before :each do
        allow(Faraday).to receive(:get).and_return(faraday_response)
      end

      it 'should return first_postamat_id' do
        http_request1.done!('')
        expect(http_request1.storage).to eq({ first_postamat_id: '637627623141d14a5523ef83' })
      end

      it 'should return array of id' do
        http_request2.done!('')
        expect(http_request2.storage).to eq({ first_postamat_id: ["637627623141d14a5523ef83", "63778ea9f423b1ba66167c6d"] })
      end

      it 'should not found result' do
        http_request3.done!('')
        expect(http_request2.storage).to eq({  })
      end
    end

    context 'when status not 200' do
      let(:faraday_response) { Faraday::Response.new(status: 404, body: example.to_json) }
      let(:http_request1) { described_class.new( url: 'http://www.example.com',
                                                 request_type: 'get',
                                                 result_selector_json: { "first_postamat_id":"/data/collection/[0]/id" },
                                                 do: 'http_request', operation_id: 1,
                                                 storage: {}) }
      let(:http_request2) { described_class.new( url: 'http://www.example.com',
                                                 request_type: 'get',
                                                 only_response_200: 'true',
                                                 result_selector_json: { "first_postamat_id":"/data/collection/[*]/id" },
                                                 do: 'http_request', operation_id: 1,
                                                 storage: {}) }


      before :each do
        allow(Faraday).to receive(:get).and_return(faraday_response)
      end

      it 'should found the result' do
        http_request1.done!('')
        expect(http_request1.storage).to eq({ first_postamat_id: '637627623141d14a5523ef83' })
      end

      it 'should be raise' do
        expect{ http_request2.done!('') }.to raise_error(StandardError)
      end
    end
  end

  describe 'status' do
    let(:faraday_response_200) { Faraday::Response.new(status: 200, body: {}.to_json) }
    let(:faraday_response_404) { Faraday::Response.new(status: 404, body: {}.to_json) }
    let(:http_request1) { described_class.new( url: 'http://www.example.com',
                                               request_type: 'get',
                                               response_status_variable: 'status',
                                               only_response_200: 'true',
                                               result_selector_json: { "first_postamat_id":"/data/collection/[0]/id" },
                                               do: 'http_request', operation_id: 1,
                                               storage: {}) }


    it 'should return status 200' do
      allow(Faraday).to receive(:get).and_return(faraday_response_200)
      http_request1.done!('')
      expect(http_request1.storage).to eq({ first_postamat_id: nil,
                                            'status' => 200 })
    end

    it 'should return status 404' do
      allow(Faraday).to receive(:get).and_return(faraday_response_404)
      expect{ http_request1.done!('') }.to raise_error(StandardError)
      expect(http_request1.storage).to eq({ 'status' => 404 })
    end
  end

  describe 'at_path' do
    let(:example) { {
      "data": {
        "collection": [
          {
            "id": "637627623141d14a5523ef83",
            "number": "123-01",
            "url": "http://20.2.2.2:8080",
            "brandId": "63513f688e100ce3fab5b0a8",
            "description": "string11111",
            "dateCreate": "2022-11-17T12:21:54.772+00:00",
            "dateUpdate": "2022-11-29T07:34:43.045+00:00"
          },
          {
            "id": "63778ea9f423b1ba66167c6d",
            "number": "124-01",
            "url": "http://20.2.2.2:8080",
            "brandId": "63513f688e100ce3fab5b0a8",
            "description": "3et345t51",
            "dateCreate": "2022-11-18T13:54:49.96+00:00",
            "dateUpdate": "2022-11-29T07:34:43.1+00:00"
          },
        ],
        "pageSize": 20,
        "currentPage": 1,
        "pageCount": 1
      },
      "isSuccess": true,
      "error": nil
    } }

    it { expect(example.deep_stringify_keys.at_path('/data/collection/[0]/id')).to eq('637627623141d14a5523ef83') }
  end

  describe 'replace_attributes' do
    context 'when attributes for replace do not exist then exception not generated' do
      let(:http_request) { described_class.new( url: 'http://www.example.com',
                                                request_type: 'get',
                                                result_selector_json: {"first_postamat_id":"/data/collection/[0]/id"},
                                                do: 'http_request', operation_id: 1,
                                                storage: {}, for_output_storage: {}) }

      it { expect{ http_request.replace_attributes }.to_not raise_exception }
    end

    context 'when attributes for replace do not exist' do
      let(:http_request) { described_class.new( url: 'http://www.example.com',
                                                request_type: 'get',
                                                result_selector_json: { "first_postamat_id":"/data/collection/[0]/id" },
                                                do: 'http_request', operation_id: 1,
                                                storage: { 'url' => 'http://url.ru' }, for_output_storage: {}) }

      before :each do
        http_request.replace_attributes
      end

      it { expect(http_request.url).to eq('http://www.example.com') }
      it { expect(http_request.request_type).to eq('get') }
      it { expect(http_request.result_selector_json).to eq({ "first_postamat_id":"/data/collection/[0]/id" }) }
      it { expect(http_request.do).to eq('http_request') }
      it { expect(http_request.storage).to eq({ 'url' => 'http://url.ru' }) }
    end

    context 'when attributes need replace' do
      let(:http_request) { described_class.new( url: '$variable(url)',
                                                request_type: 'get',
                                                result_selector_json: { "first_postamat_id":"/data/$variable(collection_name)/[0]/id" },
                                                do: 'http_request', operation_id: 1,
                                                storage: { 'url' => 'http://url.ru', 'collection_name' => 'collection' },
                                                for_output_storage: {}) }

      before :each do
        http_request.replace_attributes
      end

      it { expect(http_request.url).to eq('http://url.ru') }
      it { expect(http_request.request_type).to eq('get') }
      it { expect(http_request.result_selector_json).to eq({ "first_postamat_id":"/data/collection/[0]/id" }) }
      it { expect(http_request.do).to eq('http_request') }
      it { expect(http_request.storage).to eq({ 'url' => 'http://url.ru', 'collection_name' => 'collection' }) }
    end

    context 'when one attributeis an Array' do
      let(:http_request) { described_class.new( url: '$variable(url)',
                                                request_type: 'post',
                                                request_body: {"id"=>31,
                                                               "experiment_cases"=>
                                                                 [{"id"=>33,
                                                                   "number"=>'$variable(number1)',
                                                                   "experiment_id"=>31,
                                                                   "check"=>[],
                                                                   "do"=>
                                                                     [{"id"=>102,
                                                                       "operation_type"=>"do",
                                                                       "number"=>'$variable(number2)',
                                                                       "operation_json"=>
                                                                         {"do"=>"http_request",
                                                                          "url"=>"$variable(url)/$variable(id)",
                                                                          "response_status_variable"=>"delete_status"},
                                                                       "experiment_case_id"=>33},
                                                                      {"id"=>102,
                                                                       "operation_type"=>"do",
                                                                       "number"=>'$variable(number3)',
                                                                       "operation_json"=>
                                                                         {"do"=>"http_request",
                                                                          "url"=>"$variable(url1)/$variable(id2)",
                                                                          "response_status_variable"=>"delete_status"},
                                                                       "experiment_case_id"=>33}
                                                                     ],
                                                                   "next"=>[]}]},
                                                result_selector_json: { "first_postamat_id":"/data/$variable(collection_name)/[0]/id" },
                                                do: 'http_request', operation_id: 1,
                                                storage: { 'url' => 'http://url.ru', 'id' => '888',
                                                           'url1' => 'http://yandex.ru', 'id2' => '777',
                                                           'number1' => '1', 'number2' => '2', 'number3' => '3',
                                                           'collection_name' => 'collection'},
                                                for_output_storage: {}) }

      before :each do
        http_request.replace_attributes
      end

      it { expect(http_request.url).to eq('http://url.ru') }
      it { expect(http_request.request_type).to eq('post') }
      it { expect(http_request.result_selector_json).to eq({ "first_postamat_id":"/data/collection/[0]/id" }) }
      it { expect(http_request.do).to eq('http_request') }
      it { expect(http_request.request_body).to eq({"id"=>31,
                                                    "experiment_cases"=>
                                                      [{"id"=>33,
                                                        "number"=>'1',
                                                        "experiment_id"=>31,
                                                        "check"=>[],
                                                        "do"=>
                                                          [{"id"=>102,
                                                            "operation_type"=>"do",
                                                            "number"=>'2',
                                                            "operation_json"=>
                                                              {"do"=>"http_request",
                                                               "url"=>"http://url.ru/888",
                                                               "response_status_variable"=>"delete_status"},
                                                            "experiment_case_id"=>33},
                                                           {"id"=>102,
                                                            "operation_type"=>"do",
                                                            "number"=>'3',
                                                            "operation_json"=>
                                                              {"do"=>"http_request",
                                                               "url"=>"http://yandex.ru/777",
                                                               "response_status_variable"=>"delete_status"},
                                                            "experiment_case_id"=>33}
                                                          ],
                                                        "next"=>[]}]}) }
    end
  end
end