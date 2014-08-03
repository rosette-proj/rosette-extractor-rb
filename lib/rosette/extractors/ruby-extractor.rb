# encoding: UTF-8

require 'java'
require 'rosette/core'
require 'jruby-parser'

module Rosette
  module Extractors

    class RubyExtractor < Rosette::Core::Extractor
      protected

      def each_function_call(ruby_code)
        if block_given?
          JRubyParser.parse(ruby_code).each do |node|
            case node.node_type
              when Java::OrgJrubyparserAst::NodeType::FCALLNODE, Java::OrgJrubyparserAst::NodeType::CALLNODE
                yield node
            end
          end
        else
          to_enum(__method__, ruby_code)
        end
      end

      def valid_args?(node)
        node.args.size > 0 && node.args[0].is_a?(Java::OrgJrubyparserAst::StrNode)
      end

      def get_key(node)
        node.args[0].value
      end

      class FastGettextExtractor < RubyExtractor
        protected

        def valid_name?(node)
          node.name == '_'
        end
      end

      class RailsExtractor < RubyExtractor
        protected

        def valid_name?(node)
          node.name == 't'
        end
      end
    end

  end
end
