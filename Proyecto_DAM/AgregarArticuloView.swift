import SwiftUI

struct AgregarArticuloView: View {
    
    @Binding var isPresented: Bool
    @State private var nombre: String = ""
    @State private var cantidad: Int = 1
    @State private var prioridad: String = "Alta"
    @State private var notas: String = ""
    
    @State private var categorias: [String] = []
    @State private var tiendas: [String] = []
    
    @State private var categoriaSeleccionada: String = ""
    @State private var tiendaSeleccionada: String = ""
    
    var body: some View {
        NavigationView {
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
            }
            .navigationBarItems(leading: Button("Cancelar") {
                isPresented = false
            }, trailing: Button("Guardar") {
                // Intentar guardar el artículo con manejo de errores
                do {
                    try CoreDataManagerCompras.shared.guardarArticulo(
                        nombre: nombre,
                        cantidad: Int32(cantidad),
                        prioridad: prioridad,
                        notas: notas,
                        categoria: categoriaSeleccionada,
                        tienda: tiendaSeleccionada
                    )
                    isPresented = false  // Cerrar la vista al guardar
                } catch {
                    print("Error al guardar el artículo: \(error)") // Manejo de errores
                    // Aquí puedes mostrar una alerta al usuario si lo deseas.
                }
            })
            .onAppear {
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
        }
    }
}
