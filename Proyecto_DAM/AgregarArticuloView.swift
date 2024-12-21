import SwiftUI
import CoreData

struct AgregarArticuloView: View {
    @Binding var isPresented: Bool
    @State private var nombre: String = ""
    @State private var cantidad: Int = 1
    @State private var prioridad: String = "Alta"
    @State private var notas: String = ""
    
    @State private var categorias: [String] = []
    @State private var tiendas: [String] = []
    
    @State private var categoriaSeleccionada: String = ""
    @State private var tiendasSeleccionadas: Set<String> = []
    
    @State private var mostrarMensajeError: Bool = false
    @State private var mensajeError: String = ""
    
    var articulo: Articulo?
    
    var formularioValido: Bool {
        !nombre.isEmpty &&
        cantidad > 0 &&
        !categoriaSeleccionada.isEmpty &&
        !tiendasSeleccionadas.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del artículo")) {
                    TextField("Nombre", text: $nombre)
                        .onChange(of: nombre) { _ in validarFormulario() }
                    Stepper("Cantidad: \(cantidad)", value: $cantidad, in: 1...100)
                        .onChange(of: cantidad) { _ in validarFormulario() }
                    TextField("Notas", text: $notas)
                    Picker("Prioridad", selection: $prioridad) {
                        Text("Alta").tag("Alta")
                        Text("Baja").tag("Baja")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Categoría y Tienda")) {
                    VStack(alignment: .leading) {
                        Text("Categoría")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categorias, id: \.self) { categoria in
                                    Button(action: {
                                        categoriaSeleccionada = categoria
                                        validarFormulario()
                                    }) {
                                        Text(categoria)
                                            .padding()
                                            .background(categoriaSeleccionada == categoria ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(categoriaSeleccionada == categoria ? .white : .blue)
                                            .cornerRadius(8)
                                    }
                                    .frame(height: 40)
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Tienda(s)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tiendas, id: \.self) { tienda in
                                    Button(action: {
                                        if tiendasSeleccionadas.contains(tienda) {
                                            tiendasSeleccionadas.remove(tienda)
                                        } else {
                                            tiendasSeleccionadas.insert(tienda)
                                        }
                                        validarFormulario()
                                    }) {
                                        Text(tienda)
                                            .padding()
                                            .background(tiendasSeleccionadas.contains(tienda) ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(tiendasSeleccionadas.contains(tienda) ? .white : .blue)
                                            .cornerRadius(8)
                                    }
                                    .frame(height: 40)
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                }
                
                if mostrarMensajeError {
                    Text(mensajeError)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .navigationBarItems(
                leading: Button("Cancelar") {
                    isPresented = false
                },
                trailing: Button("Guardar") {
                    guardarArticulo()
                }
                .disabled(!formularioValido)
            )
            .onAppear {
                cargarDatos()
            }
        }
    }
    
    private func cargarDatos() {
        ApiManager.shared.fetchCategorias { categorias, error in
            if let categorias = categorias {
                self.categorias = categorias
            } else if let error = error {
                print("Error al cargar categorías: \(error.localizedDescription)")
            }
        }

        ApiManager.shared.fetchTiendas { tiendas, error in
            if let tiendas = tiendas {
                self.tiendas = tiendas
                if let articulo = articulo {
                    if let tiendasDelArticulo = articulo.tiendas?.allObjects as? [Tienda] {
                        self.tiendasSeleccionadas = Set(tiendasDelArticulo.compactMap { $0.nombre })
                    }
                }
            } else if let error = error {
                print("Error al cargar tiendas: \(error.localizedDescription)")
            }
        }
    }
    
    private func guardarArticulo() {
        do {
            let tiendasObjects = try fetchTiendasSeleccionadas(tiendasSeleccionadas)
            
            try CoreDataManagerCompras.shared.guardarArticulo(
                nombre: nombre,
                cantidad: Int32(cantidad),
                prioridad: prioridad,
                notas: notas,
                categoria: categoriaSeleccionada,
                tiendas: tiendasObjects
            )
            isPresented = false
        } catch {
            print("Error al guardar el artículo: \(error)")
        }
    }
    
    private func validarFormulario() {
        if nombre.isEmpty {
            mensajeError = "El nombre es obligatorio."
            mostrarMensajeError = true
        } else if categoriaSeleccionada.isEmpty {
            mensajeError = "Selecciona una categoría."
            mostrarMensajeError = true
        } else if tiendasSeleccionadas.isEmpty {
            mensajeError = "Selecciona al menos una tienda."
            mostrarMensajeError = true
        } else {
            mostrarMensajeError = false
        }
    }
    
    private func fetchTiendasSeleccionadas(_ tiendasSeleccionadas: Set<String>) throws -> [Tienda] {
        let fetchRequest: NSFetchRequest<Tienda> = Tienda.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nombre IN %@", Array(tiendasSeleccionadas))
        
        do {
            return try PersistenceController.shared.viewContext.fetch(fetchRequest)
        } catch {
            print("Error al obtener las tiendas: \(error)")
            throw error
        }
    }
}
