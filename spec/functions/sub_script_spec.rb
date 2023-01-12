require_relative '../../lib/functions/sub_script'
require 'json'

RSpec.describe Functions::SubScript do
  describe 'replace_attributes' do
    let(:script_example) { {"human_name"=>nil,
                            "human_description"=>nil,
                            "do"=>"sub_script",
                            "script_id"=>"31",
                            "script_json"=>
                              {"id"=>31,
                               "human_name"=>"Удалить постамат",
                               "human_description"=>
                                 "Удалить по Id\r\n" +
                                   "Если не найдено, то просто продолжить не прерываясь",
                               "user_id"=>1,
                               "state"=>"new",
                               "created_at"=>"2023-01-12T08:29:26.479Z",
                               "updated_at"=>"2023-01-12T08:30:25.921Z",
                               "sets_of_variables_json"=>nil,
                               "project_id"=>9,
                               "default_test_environment_id"=>23,
                               "experiment_cases"=>
                                 [{"id"=>33,
                                   "human_name"=>"Удалить постамат",
                                   "human_description"=>"",
                                   "user_id"=>1,
                                   "created_at"=>"2023-01-12T08:51:19.219Z",
                                   "updated_at"=>"2023-01-12T08:51:19.219Z",
                                   "number"=>1,
                                   "experiment_id"=>31,
                                   "check"=>[],
                                   "do"=>
                                     [{"id"=>102,
                                       "operation_type"=>"do",
                                       "number"=>1,
                                       "operation_json"=>
                                         {"human_name"=>nil,
                                          "human_description"=>nil,
                                          "do"=>"http_request",
                                          "url"=>"$variable(url)/$variable(id)",
                                          "request_type"=>"delete",
                                          "request_header_json"=>"",
                                          "request_body"=>"",
                                          "result_selector_json"=>"",
                                          "only_response_200"=>"",
                                          "response_status_variable"=>"delete_status"},
                                       "created_at"=>"2023-01-12T08:51:27.121Z",
                                       "updated_at"=>"2023-01-12T08:52:30.019Z",
                                       "function_name"=>"http_request",
                                       "experiment_case_id"=>33}],
                                   "next"=>[]}]}} }


    context 'when attributes need replace' do
      let(:function) { described_class.new( script_example.merge(storage: { 'url' => 'http://url.ru', 'id' => '12345' },
                                                                 for_output_storage: {})) }

      before :each do
        function.replace_attributes
      end

      it { expect(function.script_id).to eq('31') }
      it { expect(function.script_json).to eq({"id"=>31,
                                                   "human_name"=>"Удалить постамат",
                                                   "human_description"=>
                                                     "Удалить по Id\r\n" +
                                                       "Если не найдено, то просто продолжить не прерываясь",
                                                   "user_id"=>1,
                                                   "state"=>"new",
                                                   "created_at"=>"2023-01-12T08:29:26.479Z",
                                                   "updated_at"=>"2023-01-12T08:30:25.921Z",
                                                   "sets_of_variables_json"=>nil,
                                                   "project_id"=>9,
                                                   "default_test_environment_id"=>23,
                                                   "experiment_cases"=>
                                                     [{"id"=>33,
                                                       "human_name"=>"Удалить постамат",
                                                       "human_description"=>"",
                                                       "user_id"=>1,
                                                       "created_at"=>"2023-01-12T08:51:19.219Z",
                                                       "updated_at"=>"2023-01-12T08:51:19.219Z",
                                                       "number"=>1,
                                                       "experiment_id"=>31,
                                                       "check"=>[],
                                                       "do"=>
                                                         [{"id"=>102,
                                                           "operation_type"=>"do",
                                                           "number"=>1,
                                                           "operation_json"=>
                                                             {"human_name"=>nil,
                                                              "human_description"=>nil,
                                                              "do"=>"http_request",
                                                              "url"=>"$variable(url)/$variable(id)",
                                                              "request_type"=>"delete",
                                                              "request_header_json"=>"",
                                                              "request_body"=>"",
                                                              "result_selector_json"=>"",
                                                              "only_response_200"=>"",
                                                              "response_status_variable"=>"delete_status"},
                                                           "created_at"=>"2023-01-12T08:51:27.121Z",
                                                           "updated_at"=>"2023-01-12T08:52:30.019Z",
                                                           "function_name"=>"http_request",
                                                           "experiment_case_id"=>33}],
                                                       "next"=>[]}]}) }
      it { expect(function.do).to eq('sub_script') }
    end
  end
end