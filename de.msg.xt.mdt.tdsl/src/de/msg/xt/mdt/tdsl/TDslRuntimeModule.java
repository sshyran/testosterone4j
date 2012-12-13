/*
 * generated by Xtext
 */
package de.msg.xt.mdt.tdsl;

import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.eclipse.xtext.xbase.typing.ITypeProvider;

import de.msg.xt.mdt.tdsl.generator.TDslJvmModelGenerator;
import de.msg.xt.mdt.tdsl.jvmmodel.TDslCompiler;
import de.msg.xt.mdt.tdsl.typeprovider.TDslTypeProvider;

/**
 * Use this class to register components to be used at runtime / without the
 * Equinox extension registry.
 */
@SuppressWarnings("restriction")
public class TDslRuntimeModule extends
		de.msg.xt.mdt.tdsl.AbstractTDslRuntimeModule {

	@Override
	public Class<? extends ITypeProvider> bindITypeProvider() {
		return TDslTypeProvider.class;
	}

	// contributed by org.eclipse.xtext.generator.xbase.XbaseGeneratorFragment
	@Override
	public Class<? extends org.eclipse.xtext.generator.IGenerator> bindIGenerator() {
		return TDslJvmModelGenerator.class;
	}

	public Class<? extends XbaseCompiler> bindXbaseCompiler() {
		return TDslCompiler.class;
	}
}
