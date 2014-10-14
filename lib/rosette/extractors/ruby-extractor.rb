# encoding: UTF-8

require 'rosette/core'
require 'jruby-parser'

module Rosette
  module Extractors

    class RubyExtractor < Rosette::Core::Extractor
      protected

      # For some reason, when iterating over a jruby-parser AST, nodes with the
      # same object_id are yielded multiple times. The seen_objects hash in this
      # function is meant to de-duplicate them so identical phrases aren't returned.
      def each_function_call(ruby_code)
        seen_objects = {}

        if block_given?
          parse(ruby_code).each do |node|
            unless seen_objects[node.object_id]
              case node.node_type
                when Java::OrgJrubyparserAst::NodeType::FCALLNODE, Java::OrgJrubyparserAst::NodeType::CALLNODE
                  yield node
              end
            end

            seen_objects[node.object_id] = true
          end
        else
          to_enum(__method__, ruby_code)
        end
      end

      def parse(ruby_code)
        JRubyParser.parse(ruby_code, version: JRubyParser::Compat::RUBY2_0)
      rescue Java::OrgJrubyparserLexer::SyntaxException => e
        raise Rosette::Core::SyntaxError.new('syntax error', e, :ruby)
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
    end

  end
end
