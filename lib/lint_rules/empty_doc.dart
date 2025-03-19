import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// Lint rule to not mention Voldemort in a variable's name
class EmptyDoc extends DartLintRule {
  EmptyDoc() : super(code: _code);

  // Lint rule metadata
  static const _code = LintCode(
    name: 'empty_doc',
    problemMessage: 'Отсутствует документация',
    correctionMessage: 'Добавьте документацию',
    errorSeverity: ErrorSeverity.WARNING,
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
      if (element.kind == ElementKind.LOCAL_VARIABLE || element.kind == ElementKind.CONSTRUCTOR) return;
      final isDocumentated =
          declaration.documentationComment?.isDocumentation ?? false;
      // print(
      //     '$isDocumentated + ${declaration.declaredElement?.name ?? 'empty'}');

      if (!isDocumentated) {
        reporter.atElement(
          element,
          code,
        );
      }
    });
  }
}
