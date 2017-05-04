//  This file was automatically generated and should not be edited.

import Apollo

public final class CreateNetworkMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateNetwork($name: String!, $bssid: String!, $discoverable: Boolean!, $latitude: Float!, $longitude: Float!, $city: String!, $password: String!) {" +
    "  createNetwork(name: $name, bssid: $bssid, discoverable: $discoverable, latitude: $latitude, longitude: $longitude, city: $city, password: $password) {" +
    "    __typename" +
    "    name" +
    "    discoverable" +
    "  }" +
    "}"

  public let name: String
  public let bssid: String
  public let discoverable: Bool
  public let latitude: Double
  public let longitude: Double
  public let city: String
  public let password: String

  public init(name: String, bssid: String, discoverable: Bool, latitude: Double, longitude: Double, city: String, password: String) {
    self.name = name
    self.bssid = bssid
    self.discoverable = discoverable
    self.latitude = latitude
    self.longitude = longitude
    self.city = city
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["name": name, "bssid": bssid, "discoverable": discoverable, "latitude": latitude, "longitude": longitude, "city": city, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let createNetwork: CreateNetwork?

    public init(reader: GraphQLResultReader) throws {
      createNetwork = try reader.optionalValue(for: Field(responseName: "createNetwork", arguments: ["name": reader.variables["name"], "bssid": reader.variables["bssid"], "discoverable": reader.variables["discoverable"], "latitude": reader.variables["latitude"], "longitude": reader.variables["longitude"], "city": reader.variables["city"], "password": reader.variables["password"]]))
    }

    public struct CreateNetwork: GraphQLMappable {
      public let __typename: String
      public let name: String?
      public let discoverable: Bool?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        discoverable = try reader.optionalValue(for: Field(responseName: "discoverable"))
      }
    }
  }
}

public final class ValidateUserQuery: GraphQLQuery {
  public static let operationDefinition =
    "query ValidateUser {" +
    "  validateUser {" +
    "    __typename" +
    "    valid" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let validateUser: ValidateUser?

    public init(reader: GraphQLResultReader) throws {
      validateUser = try reader.optionalValue(for: Field(responseName: "validateUser"))
    }

    public struct ValidateUser: GraphQLMappable {
      public let __typename: String
      public let valid: Bool?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        valid = try reader.optionalValue(for: Field(responseName: "valid"))
      }
    }
  }
}

public final class SearchForNetworksQuery: GraphQLQuery {
  public static let operationDefinition =
    "query SearchForNetworks($city: String!, $latitude: Float!, $longitude: Float!) {" +
    "  networks(city: $city, latitude: $latitude, longitude: $longitude) {" +
    "    __typename" +
    "    name" +
    "    distance" +
    "  }" +
    "}"

  public let city: String
  public let latitude: Double
  public let longitude: Double

  public init(city: String, latitude: Double, longitude: Double) {
    self.city = city
    self.latitude = latitude
    self.longitude = longitude
  }

  public var variables: GraphQLMap? {
    return ["city": city, "latitude": latitude, "longitude": longitude]
  }

  public struct Data: GraphQLMappable {
    public let networks: [Network?]?

    public init(reader: GraphQLResultReader) throws {
      networks = try reader.optionalList(for: Field(responseName: "networks", arguments: ["city": reader.variables["city"], "latitude": reader.variables["latitude"], "longitude": reader.variables["longitude"]]))
    }

    public struct Network: GraphQLMappable {
      public let __typename: String
      public let name: String?
      public let distance: Double?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        distance = try reader.optionalValue(for: Field(responseName: "distance"))
      }
    }
  }
}

public final class UserLoginMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation UserLogin($email: String!, $password: String!) {" +
    "  login(email: $email, password: $password) {" +
    "    __typename" +
    "    token" +
    "  }" +
    "}"

  public let email: String
  public let password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let login: Login?

    public init(reader: GraphQLResultReader) throws {
      login = try reader.optionalValue(for: Field(responseName: "login", arguments: ["email": reader.variables["email"], "password": reader.variables["password"]]))
    }

    public struct Login: GraphQLMappable {
      public let __typename: String
      public let token: String?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
      }
    }
  }
}

public final class SignUpUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SignUpUser($name: String!, $email: String!, $password: String!) {" +
    "  signup(name: $name, email: $email, password: $password) {" +
    "    __typename" +
    "    token" +
    "  }" +
    "}"

  public let name: String
  public let email: String
  public let password: String

  public init(name: String, email: String, password: String) {
    self.name = name
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["name": name, "email": email, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let signup: Signup?

    public init(reader: GraphQLResultReader) throws {
      signup = try reader.optionalValue(for: Field(responseName: "signup", arguments: ["name": reader.variables["name"], "email": reader.variables["email"], "password": reader.variables["password"]]))
    }

    public struct Signup: GraphQLMappable {
      public let __typename: String
      public let token: String?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
      }
    }
  }
}