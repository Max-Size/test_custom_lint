import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _validLastLineSpaceDoc = RegExp(r'\/\/\/[\s]*$');

// Lint rule to not mention Voldemort in a variable's name
class WrongDocStyle extends DartLintRule {
  WrongDocStyle() : super(code: _code);

  // Lint rule metadata
  static const _code = LintCode(
    name: 'wrong_doc_style',
    problemMessage: 'Не корректный стиль документации',
  );

  // `run` is where you analyze a file and report lint errors
  // Invoked on a file automatically on every file edit
  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addDeclaration((declaration) {
      final element = declaration.declaredElement;
      if (element == null) return;
      final docComment = declaration.documentationComment;
      final isDocumentated = docComment?.isDocumentation ?? false;
      if (!isDocumentated || docComment == null) return;
      var isValid = true;
      final docLines = docComment.tokens;
      if (docLines.isEmpty) return;
      print(docLines);
      if (element.kind == ElementKind.CLASS || element.kind == ElementKind.ENUM) {
        isValid = docLines.length > 1;
      }
      if (docLines.length > 1 && !_validLastLineSpaceDoc.hasMatch(docLines.last.toString())) {
        isValid = false;
      }
      if (!isValid) {
        reporter.atElement(
          element,
          code,
        );
      }
    });
  }
}
