//@ts-ignore
import { Elm } from "./Main.elm";
import "../src";

const app = Elm.Main.init({
  node: document.querySelector("main"),
  flags: null,
});
