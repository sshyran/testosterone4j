package de.msg.xt.mdt.tdsl.jvmmodel

import com.google.inject.Inject
import de.msg.xt.mdt.tdsl.tDsl.Activity
import de.msg.xt.mdt.tdsl.tDsl.Control
import de.msg.xt.mdt.tdsl.tDsl.DataType
import de.msg.xt.mdt.tdsl.tDsl.TagsDeclaration
import javax.xml.bind.annotation.XmlAttribute
import javax.xml.bind.annotation.XmlRootElement
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmConstructor
import org.eclipse.xtext.common.types.JvmVisibility
import org.eclipse.xtext.common.types.TypesFactory
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xbase.lib.Procedures$Procedure1

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class TDslJvmModelInferrer extends AbstractModelInferrer {

    /**
     * convenience API to build and initialize JVM types and their members.
     */
	@Inject extension JvmTypesBuilder
	
	@Inject extension IQualifiedNameProvider
	
	@Inject extension TypeReferences references
	

   	def dispatch void infer(Activity activity, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		
   		acceptor.accept(activity.toClass(activity.fullyQualifiedName)).initializeLater([
   			
  			for (param : activity.inputParameter) {
   				members += param.toField(param.name, param.newTypeRef(param.dataType.fullyQualifiedName.toString))
   			}
   				
   			for (field : activity.fields) {
   				members += field.toField(field.name, field.newTypeRef(field.control.fullyQualifiedName.toString))
   			}

   			members += activity.toConstructor [
   				for (param : activity.inputParameter) {
   					parameters += param.toParameter(param.name, param.newTypeRef(param.dataType.fullyQualifiedName.toString))
   				}
   			]
   			
			for (field : activity.fields) {
				members += field.toGetter(field.name, field.newTypeRef(field.control.fullyQualifiedName.toString))
			}
   		])
   	}


   	def dispatch void infer(Control control, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		
   		acceptor.accept(control.toClass(control.fullyQualifiedName)).initializeLater([
   			
   			members += control.toField("id", control.newTypeRef(typeof(String)))
   			
   			for (operation : control.operations) {
   				for (opParam : operation.params) {
   					members += opParam.toField(opParam.name, opParam.type.mappedBy)
   				}
   			}
   			   			
   			val	Procedure1<ITreeAppendable> body = [it.append(
					'''
						this.id = id;
					''')]
			members += control.toConstructor("id", body) [
   				parameters += control.toParameter("id", control.newTypeRef(typeof(String)))
   				setVisibility(JvmVisibility::PUBLIC)
   			]
   			
   			for (operation : control.operations) {
   				val returnType = 
   					if (operation.returnType != null)
   						operation.returnType.mappedBy
   					else
   						references.getTypeForName(typeof(void) as Class<?>, operation)
   				members += operation.toMethod(operation.name, returnType) [
   					for (param : operation.params) {
   						parameters += param.toParameter(param.name, param.type.mappedBy)
   					}
   					
//   					setBody [
//   						for (param : operation.params) {
//   							it.append('''
//   								this.«param.name» = «param.name»;
//   							''')
//   						}
//   					]
   				]
   			}
   		])
   	}

   		
   	def dispatch void infer(DataType dataType, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		
   		acceptor.accept(dataType.toEnumerationType(dataType.fullyQualifiedName.toString + "EquivalenceClass2")[]).initializeLater [
   			for (clazz : dataType.classes) {
   				members += clazz.toEnumerationLiteral(clazz.name);
   			}
   		]

   		acceptor.accept(dataType.toClass(dataType.fullyQualifiedName.toString + "EquivalenceClass")).initializeLater [
   				it.superTypes += dataType.newTypeRef("de.msg.xt.mdt.base.EquivalenceClass")
   				members += dataType.toField("EMPTY_ID", dataType.newTypeRef(typeof(short))) [
   					setStatic(true)
   					setFinal(true)
   					setInitializer [
   						it.append('''-1''')
   					]
   				]
   				
   				var i = 0
   				for (clazz : dataType.classes) { 
   					val field = clazz.toField(clazz.name + "_ID", clazz.newTypeRef(typeof(short))) [					
   						setStatic(true)
   						final = true
   					]
   					val value = i 
   					field.setInitializer[
   						it.append('''«value»''')
   					]
   					members += field
   					i = i + 1
   				}

				val singletonField = dataType.toField("INSTANCE", dataType.newTypeRef(it.fullyQualifiedName.toString)) [
   					it.setStatic(true)
   					it.setVisibility(JvmVisibility::PUBLIC)
   					it.setFinal(true)
   				]
   				singletonField.setInitializer [
   					it.append(
   					'''new «singletonField.type.simpleName»(EMPTY_ID''')
   					it.append(''', new Tags[] {})''')
   				]
   				members += singletonField
	
   				for (clazz : dataType.classes) {
   					val field = clazz.toField(clazz.name, clazz.newTypeRef(it.fullyQualifiedName.toString)) [
   						it.setStatic(true)
   						it.setVisibility(JvmVisibility::PUBLIC)
   						it.setFinal(true)
   					]
   					val tags = clazz.tags
   					field.setInitializer [
   						it.append(
   						'''new «field.type.simpleName»(«clazz.name»_ID''')
   						it.append(''', new Tags[] {''')
   						var z = 0
   						for (tag : tags) {
   							if (z != 0)
   								it.append(''', ''')
   							it.append('''«dataType.eContainer.fullyQualifiedName.toString».Tags.«tag.name.toString»''')
   							z = z + 1
   						}
   						it.append('''})''')
   					]
   					members += field
   				}
   				
   				val valuesField = dataType.toField("VALUES", dataType.newTypeRef(it.fullyQualifiedName.toString).createArrayType) [
   					it.setStatic(true)
   					it.setFinal(true)
   				]
   				valuesField.setInitializer[
   					it.append('''new «valuesField.type.simpleName» {''')
   					var j = dataType.classes.size
   					for (clazz : dataType.classes) {
   						val name = clazz.name
   						it.append('''«name»''')
   						if (j > 1) {
   							it.append(''',''')
   						}
   						j = j - 1
   					}
   					it.append('''}''')
   				]
   				members += valuesField
   				
   				members += dataType.toField("allValues", dataType.newTypeRef("java.util.Set", dataType.newTypeRef("de.msg.xt.mdt.base.EquivalenceClass")))
   				
				members += dataType.toField("id", dataType.newTypeRef(typeof(short)))

				members += dataType.toField("value", dataType.newTypeRef(typeof(String)))
				
				members += dataType.toField("tags", dataType.newTypeRef(dataType.eContainer.fullyQualifiedName.toString + ".Tags").createArrayType)
				
				members += dataType.toConstructor [
				]   				
				
				val	Procedure1<ITreeAppendable> body = [it.append(
					'''
						this.id = id;
						this.tags = tags;
					''')]
				val constructor = dataType.toConstructor("id", body) [
					parameters += dataType.toParameter("id", dataType.newTypeRef(typeof(short)))
					parameters += dataType.toParameter("tags", dataType.newTypeRef(dataType.eContainer.fullyQualifiedName.toString + ".Tags").createArrayType)
				]			
				members += constructor
				
				members += dataType.toGetter("id", dataType.newTypeRef(typeof(short)))

				members += dataType.toGetter("value", dataType.newTypeRef(typeof(String)))

				packageName = dataType.eContainer.fullyQualifiedName.toString
				members += dataType.toGetter("tags", dataType.newTypeRef(packageName + ".Tags").createArrayType)				

				members += dataType.toMethod("values", dataType.newTypeRef("java.util.Set", dataType.newTypeRef("de.msg.xt.mdt.base.EquivalenceClass"))) [
					setBody [
						it.append('''
							if(allValues == null) {
								allValues = new java.util.HashSet<EquivalenceClass>();
								java.util.Collections.addAll(allValues, VALUES);
							}
							return allValues;
						''')
					]
				]
				
				members += dataType.toMethod("getById", dataType.newTypeRef(it.fullyQualifiedName.toString)) [
					parameters += dataType.toParameter("id", dataType.newTypeRef(typeof(short)))
					setBody [
						it.append('''
							for (EquivalenceClass value : values()) {
								StringDTEquivalenceClass strValue = (StringDTEquivalenceClass)value;
								if (strValue.getId() == id) {
									return strValue;
								}
							}
							return null;
						''')
					]
				]
   			]  			
   		
   		acceptor.accept(dataType.toClass(dataType.fullyQualifiedName)).initializeLater([
   			annotations += dataType.toAnnotation(typeof(XmlRootElement))
   			
			members += dataType.toField("value", dataType.type.mappedBy) [
				annotations += dataType.toAnnotation(typeof(XmlAttribute))
			]
			members += dataType.toField("equivalenceClass", dataType.newTypeRef(dataType.fullyQualifiedName.toString + "EquivalenceClass")) [
				annotations += dataType.toAnnotation(typeof(XmlAttribute))
//				annotations += dataType.toAnnotation(typeof(XmlJavaTypeAdapter), typeof(StringDTEquivalenceClassAdapter))
			]
			
			val	Procedure1<ITreeAppendable> body = [it.append(
					'''
						this.value = value;
						this.equivalenceClass = equivalenceClass;
					''')]
			members += dataType.toConstructor("value", body) [
				setVisibility(JvmVisibility::PUBLIC)
				parameters += dataType.toParameter("value", dataType.type.mappedBy)
				parameters += dataType.toParameter("equivalenceClass", dataType.newTypeRef(dataType.fullyQualifiedName.toString + "EquivalenceClass"))
			]
			
			members += dataType.toGetter("value", dataType.type.mappedBy)
			members += dataType.toGetter("equivalenceClass", dataType.newTypeRef(dataType.fullyQualifiedName.toString + "EquivalenceClass"))
   		])
   	}
   	
   	def dispatch void infer(TagsDeclaration tags, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		acceptor.accept(tags.toEnumerationType(tags.eContainer.fullyQualifiedName.toString + ".Tags") [
   			for (tag : tags.tags) {
   				members += toEnumerationLiteral(tag.name)
   			}
   		])
   	}   		


	def toConstructor(EObject sourceElement, String simpleName, Procedure1<ITreeAppendable> body, Procedure1<JvmConstructor> init) {
		val constructor = TypesFactory::eINSTANCE.createJvmConstructor
		constructor.simpleName = simpleName
		setBody(constructor, body)
		if (init != null && simpleName != null)
			init.apply(constructor)
		associate(sourceElement, constructor)
	}
}

