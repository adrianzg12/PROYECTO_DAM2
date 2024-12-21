import SwiftUI

struct EditarArticuloView: View {
    @Binding var articulo: Articulo
    @Environment(\.presentationMode) var presentationMode

    @State private var nombre: String = ""
    @State private var cantidad: Int = 1
    @State private var prioridad: String = "Baja"
    @State private var notas: String = ""
    @State private var categorias: [String] = []
    @State private var tiendas: [String] = []
    @State private var categoriaSeleccionada: String = ""
    @State private var tiendaSeleccionada: String = ""
    
    @State private var showDeleteConfirmation = false

    init(articulo: Binding<Articulo>) {
        _articulo = articulo
        _nombre = State(initialValue: articulo.wrappedValue.nombre ?? "")
        _cantidad = State(initialValue: Int(articulo.wrappedValue.cantidad))
        _prioridad = State(initialValue: articulo.wrappedValue.prioridad ?? "Baja")
        _notas = State(initialValue: articulo.wrappedValue.notas ?? "")
        _categoriaSeleccionada = State(initialValue: articulo.wrappedValue.categoria ?? "")
        _tiendaSeleccionada = State(initialValue: articulo.wrappedValue.tienda ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Detalles del artículo")) {
                TextField("Nombre", text: $nombre)
                Stepper("Cantidad: \(cantidad)", value: $cantidad, in: 1...100)
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
                    
                    // Categorías como botones
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categorias, id: \.self) { categoria in
                                Button(action: {
                                    categoriaSeleccionada = categoria
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
                    Text("Tienda")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Tiendas como botones
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tiendas, id: \.self) { tienda in
                                Button(action: {
                                    tiendaSeleccionada = tienda
                                }) {
                                    Text(tienda)
                                        .padding()
                                        .background(tiendaSeleccionada == tienda ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(tiendaSeleccionada == tienda ? .white : .blue)
                                        .cornerRadius(8)
                                }
                                .frame(height: 40)
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
            }
            
            // Sección de acciones
            Section {
                Button("Eliminar Artículo") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarItems(trailing: Button("Guardar Cambios") {
            guardarCambios()
        })
        .onAppear {
            cargarCategoriasYTiendas()
        }
        .navigationTitle("Editar Artículo")
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Eliminar Artículo"),
                message: Text("¿Estás seguro de que deseas eliminar este artículo?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    eliminarArticulo()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func cargarCategoriasYTiendas() {
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
            } else if let error = error {
                print("Error al cargar tiendas: \(error.localizedDescription)")
            }
        }
    }

    private func guardarCambios() {
        do {
            articulo.nombre = nombre
            articulo.cantidad = Int32(cantidad)
            articulo.prioridad = prioridad
            articulo.notas = notas.isEmpty ? nil : notas
            articulo.categoria = categoriaSeleccionada
            articulo.tienda = tiendaSeleccionada
            try articulo.managedObjectContext?.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error al guardar cambios: \(error)")
        }
    }

    // Función para eliminar el artículo
    private func eliminarArticulo() {
        do {
            try CoreDataManagerCompras.shared.eliminarArticulo(articulo: articulo)
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error al eliminar artículo: \(error)")
        }
    }
}
